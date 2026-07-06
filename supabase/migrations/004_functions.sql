-- =============================================
-- Bondly Backend Migration: Database Functions
-- =============================================

-- =============================================
-- Helper Functions for RLS (in public schema)
-- =============================================

-- Get current user's role from metadata
CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS TEXT AS $$
  SELECT COALESCE(
    (auth.jwt() -> 'user_metadata' ->> 'role'),
    'client'
  )::TEXT;
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- Get current user's company name from metadata
CREATE OR REPLACE FUNCTION public.get_user_company()
RETURNS TEXT AS $$
  SELECT (auth.jwt() -> 'user_metadata' ->> 'company_name')::TEXT;
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- Get current user's account number from metadata
CREATE OR REPLACE FUNCTION public.get_user_account()
RETURNS INTEGER AS $$
  SELECT COALESCE(
    (auth.jwt() -> 'user_metadata' ->> 'account_number')::INTEGER,
    0
  );
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- Check if current user is admin or superAdmin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
  SELECT public.get_user_role() IN ('admin', 'superAdmin');
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- =============================================
-- Utility Functions
-- =============================================

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Generate deterministic UUID from MongoDB ObjectId (for migration)
-- Uses extensions schema where uuid-ossp is installed
CREATE OR REPLACE FUNCTION mongo_id_to_uuid(mongo_id TEXT)
RETURNS UUID AS $$
BEGIN
  -- Use uuid v5 with DNS namespace for deterministic conversion
  RETURN extensions.uuid_generate_v5(extensions.uuid_ns_dns(), 'bondly.mongo.' || mongo_id);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- =============================================
-- Business Logic Functions
-- =============================================

-- Create acknowledgment with full validation and side effects
CREATE OR REPLACE FUNCTION create_acknowledgment(
    p_badge_id UUID,
    p_recipients UUID[],
    p_message TEXT DEFAULT NULL
)
RETURNS JSON AS $$
DECLARE
    v_sender_id UUID;
    v_badge RECORD;
    v_sender RECORD;
    v_total_points INTEGER;
    v_acknowledgment_id UUID;
    v_recipient_id UUID;
    v_feed_id UUID;
    v_current_month TEXT;
    v_existing_count INTEGER;
BEGIN
    -- Get current user
    v_sender_id := auth.uid();
    IF v_sender_id IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Usuario no autenticado');
    END IF;

    -- Get badge info
    SELECT * INTO v_badge FROM badges WHERE id = p_badge_id AND visible = TRUE AND is_active = TRUE;
    IF v_badge IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Badge no encontrado o inactivo');
    END IF;

    -- Get sender info
    SELECT * INTO v_sender FROM users WHERE id = v_sender_id AND visible = TRUE;
    IF v_sender IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Usuario no encontrado');
    END IF;

    -- Calculate total points needed
    v_total_points := v_badge.value * array_length(p_recipients, 1);

    -- Validate sender has enough gifted points
    IF v_sender.gifted_points < v_total_points THEN
        RETURN json_build_object('success', false, 'message', 'Puntos insuficientes');
    END IF;

    -- Check for duplicate acknowledgments in current month
    v_current_month := TO_CHAR(NOW(), 'YYYY-MM');
    FOREACH v_recipient_id IN ARRAY p_recipients LOOP
        SELECT COUNT(*) INTO v_existing_count
        FROM acknowledgments a
        JOIN acknowledgment_recipients ar ON ar.acknowledgment_id = a.id
        WHERE a.sender_id = v_sender_id
          AND a.badge_id = p_badge_id
          AND ar.user_id = v_recipient_id
          AND TO_CHAR(a.created_at, 'YYYY-MM') = v_current_month;

        IF v_existing_count > 0 THEN
            RETURN json_build_object('success', false, 'message', 'Ya otorgaste este reconocimiento este mes');
        END IF;
    END LOOP;

    -- Create acknowledgment
    INSERT INTO acknowledgments (badge_id, sender_id, message, account, visible)
    VALUES (p_badge_id, v_sender_id, p_message, v_sender.account_number, TRUE)
    RETURNING id INTO v_acknowledgment_id;

    -- Add recipients and update their points
    FOREACH v_recipient_id IN ARRAY p_recipients LOOP
        -- Add recipient
        INSERT INTO acknowledgment_recipients (acknowledgment_id, user_id)
        VALUES (v_acknowledgment_id, v_recipient_id);

        -- Update recipient's points
        UPDATE users
        SET points_received = points_received + v_badge.value,
            updated_at = NOW()
        WHERE id = v_recipient_id;

        -- Create activity for recipient
        INSERT INTO activities (user_id, title, content, read, company_name)
        SELECT v_recipient_id,
               'Nuevo reconocimiento',
               'Has recibido un reconocimiento de ' || v_sender.complete_name,
               FALSE,
               v_sender.company_name;
    END LOOP;

    -- Deduct points from sender
    UPDATE users
    SET gifted_points = gifted_points - v_total_points,
        updated_at = NOW()
    WHERE id = v_sender_id;

    -- Create feed entry
    INSERT INTO account_feeds (account, header, body, sender_id, type, badge_id, visible)
    VALUES (
        v_sender.account_number,
        v_sender.complete_name || ' dio un reconocimiento',
        p_message,
        v_sender_id,
        'reconocimiento',
        p_badge_id,
        TRUE
    )
    RETURNING id INTO v_feed_id;

    -- Create badge report entries
    FOREACH v_recipient_id IN ARRAY p_recipients LOOP
        INSERT INTO badge_reports (category_id, badge_id, sender_id, receiver_id, sender_profile_id, receiver_profile_id)
        SELECT
            v_badge.category_id,
            p_badge_id,
            v_sender_id,
            v_recipient_id,
            (SELECT id FROM user_profiles WHERE user_id = v_sender_id),
            (SELECT id FROM user_profiles WHERE user_id = v_recipient_id);
    END LOOP;

    RETURN json_build_object(
        'success', true,
        'message', 'Reconocimiento creado exitosamente',
        'data', json_build_object(
            'acknowledgment_id', v_acknowledgment_id,
            'feed_id', v_feed_id,
            'points_deducted', v_total_points
        )
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Add item to cart
CREATE OR REPLACE FUNCTION add_to_cart(
    p_reward_id UUID,
    p_quantity INTEGER DEFAULT 1,
    p_cart_type cart_type DEFAULT 'cart'
)
RETURNS JSON AS $$
DECLARE
    v_user_id UUID;
    v_cart_id UUID;
    v_reward RECORD;
    v_existing_item RECORD;
    v_new_quantity INTEGER;
    v_new_total INTEGER;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Usuario no autenticado');
    END IF;

    -- Get reward info
    SELECT * INTO v_reward FROM rewards WHERE id = p_reward_id AND visible = TRUE AND enable = TRUE;
    IF v_reward IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Recompensa no encontrada');
    END IF;

    -- Get or create cart
    SELECT id INTO v_cart_id FROM carts WHERE user_id = v_user_id AND type = p_cart_type;
    IF v_cart_id IS NULL THEN
        INSERT INTO carts (user_id, type, company_name)
        SELECT v_user_id, p_cart_type, company_name FROM users WHERE id = v_user_id
        RETURNING id INTO v_cart_id;
    END IF;

    -- Check if item already in cart
    SELECT * INTO v_existing_item FROM cart_items WHERE cart_id = v_cart_id AND reward_id = p_reward_id;

    IF v_existing_item IS NOT NULL THEN
        -- Update quantity
        v_new_quantity := v_existing_item.quantity + p_quantity;
        UPDATE cart_items SET quantity = v_new_quantity, updated_at = NOW()
        WHERE id = v_existing_item.id;
    ELSE
        -- Add new item
        INSERT INTO cart_items (cart_id, reward_id, quantity)
        VALUES (v_cart_id, p_reward_id, p_quantity);
    END IF;

    -- Recalculate total
    SELECT COALESCE(SUM(ci.quantity * r.points), 0) INTO v_new_total
    FROM cart_items ci
    JOIN rewards r ON r.id = ci.reward_id
    WHERE ci.cart_id = v_cart_id;

    UPDATE carts SET total = v_new_total, updated_at = NOW() WHERE id = v_cart_id;

    RETURN json_build_object(
        'success', true,
        'message', 'Producto agregado al carrito',
        'data', json_build_object('cart_id', v_cart_id, 'total', v_new_total)
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Remove item from cart
CREATE OR REPLACE FUNCTION remove_from_cart(
    p_reward_id UUID,
    p_cart_type cart_type DEFAULT 'cart'
)
RETURNS JSON AS $$
DECLARE
    v_user_id UUID;
    v_cart_id UUID;
    v_new_total INTEGER;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Usuario no autenticado');
    END IF;

    -- Get cart
    SELECT id INTO v_cart_id FROM carts WHERE user_id = v_user_id AND type = p_cart_type;
    IF v_cart_id IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Carrito no encontrado');
    END IF;

    -- Remove item
    DELETE FROM cart_items WHERE cart_id = v_cart_id AND reward_id = p_reward_id;

    -- Recalculate total
    SELECT COALESCE(SUM(ci.quantity * r.points), 0) INTO v_new_total
    FROM cart_items ci
    JOIN rewards r ON r.id = ci.reward_id
    WHERE ci.cart_id = v_cart_id;

    UPDATE carts SET total = v_new_total, updated_at = NOW() WHERE id = v_cart_id;

    RETURN json_build_object('success', true, 'message', 'Producto eliminado', 'data', json_build_object('total', v_new_total));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Checkout cart (create exchanges)
CREATE OR REPLACE FUNCTION checkout_cart()
RETURNS JSON AS $$
DECLARE
    v_user_id UUID;
    v_user RECORD;
    v_cart RECORD;
    v_item RECORD;
    v_total_points INTEGER;
    v_exchange_ids UUID[];
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Usuario no autenticado');
    END IF;

    -- Get user info
    SELECT * INTO v_user FROM users WHERE id = v_user_id AND visible = TRUE;
    IF v_user IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Usuario no encontrado');
    END IF;

    -- Get cart
    SELECT * INTO v_cart FROM carts WHERE user_id = v_user_id AND type = 'cart';
    IF v_cart IS NULL OR v_cart.total = 0 THEN
        RETURN json_build_object('success', false, 'message', 'Carrito vacío');
    END IF;

    -- Validate user has enough points
    IF v_user.points_received < v_cart.total THEN
        RETURN json_build_object('success', false, 'message', 'Puntos insuficientes');
    END IF;

    v_exchange_ids := ARRAY[]::UUID[];

    -- Create exchanges for each cart item
    FOR v_item IN
        SELECT ci.*, r.points, r.name as reward_name
        FROM cart_items ci
        JOIN rewards r ON r.id = ci.reward_id
        WHERE ci.cart_id = v_cart.id
    LOOP
        FOR i IN 1..v_item.quantity LOOP
            INSERT INTO exchanges (user_id, reward_id, code, status, company_name)
            VALUES (
                v_user_id,
                v_item.reward_id,
                UPPER(SUBSTRING(MD5(RANDOM()::TEXT) FROM 1 FOR 8)),
                'En espera',
                v_user.company_name
            )
            RETURNING id INTO v_exchange_ids[array_length(v_exchange_ids, 1) + 1];
        END LOOP;
    END LOOP;

    -- Deduct points from user
    UPDATE users
    SET points_received = points_received - v_cart.total,
        updated_at = NOW()
    WHERE id = v_user_id;

    -- Clear cart
    DELETE FROM cart_items WHERE cart_id = v_cart.id;
    UPDATE carts SET total = 0, updated_at = NOW() WHERE id = v_cart.id;

    -- Create feed entry for exchange
    INSERT INTO account_feeds (account, header, body, sender_id, type, visible)
    VALUES (
        v_user.account_number,
        v_user.complete_name || ' canjeó recompensas',
        'Canjeó ' || v_cart.total || ' puntos',
        v_user_id,
        'canje',
        TRUE
    );

    RETURN json_build_object(
        'success', true,
        'message', 'Canje realizado exitosamente',
        'data', json_build_object(
            'exchange_ids', v_exchange_ids,
            'total_points', v_cart.total
        )
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Toggle like on feed
CREATE OR REPLACE FUNCTION toggle_feed_like(p_feed_id UUID)
RETURNS JSON AS $$
DECLARE
    v_user_id UUID;
    v_existing_like UUID;
    v_action TEXT;
    v_like_count INTEGER;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Usuario no autenticado');
    END IF;

    -- Check if like exists
    SELECT id INTO v_existing_like FROM feed_likes WHERE feed_id = p_feed_id AND user_id = v_user_id;

    IF v_existing_like IS NOT NULL THEN
        DELETE FROM feed_likes WHERE id = v_existing_like;
        v_action := 'unliked';
    ELSE
        INSERT INTO feed_likes (feed_id, user_id) VALUES (p_feed_id, v_user_id);
        v_action := 'liked';
    END IF;

    -- Get new count
    SELECT COUNT(*) INTO v_like_count FROM feed_likes WHERE feed_id = p_feed_id;

    RETURN json_build_object(
        'success', true,
        'action', v_action,
        'like_count', v_like_count
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Add comment to feed
CREATE OR REPLACE FUNCTION add_feed_comment(p_feed_id UUID, p_message TEXT)
RETURNS JSON AS $$
DECLARE
    v_user_id UUID;
    v_comment_id UUID;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Usuario no autenticado');
    END IF;

    IF p_message IS NULL OR LENGTH(TRIM(p_message)) = 0 THEN
        RETURN json_build_object('success', false, 'message', 'El mensaje no puede estar vacío');
    END IF;

    INSERT INTO feed_comments (feed_id, user_id, message)
    VALUES (p_feed_id, v_user_id, p_message)
    RETURNING id INTO v_comment_id;

    RETURN json_build_object(
        'success', true,
        'message', 'Comentario agregado',
        'data', json_build_object('comment_id', v_comment_id)
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Toggle like on reward
CREATE OR REPLACE FUNCTION toggle_reward_like(p_reward_id UUID)
RETURNS JSON AS $$
DECLARE
    v_user_id UUID;
    v_existing_like UUID;
    v_action TEXT;
    v_like_count INTEGER;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Usuario no autenticado');
    END IF;

    SELECT id INTO v_existing_like FROM reward_likes WHERE reward_id = p_reward_id AND user_id = v_user_id;

    IF v_existing_like IS NOT NULL THEN
        DELETE FROM reward_likes WHERE id = v_existing_like;
        v_action := 'unliked';
    ELSE
        INSERT INTO reward_likes (reward_id, user_id) VALUES (p_reward_id, v_user_id);
        v_action := 'liked';
    END IF;

    SELECT COUNT(*) INTO v_like_count FROM reward_likes WHERE reward_id = p_reward_id;

    RETURN json_build_object('success', true, 'action', v_action, 'like_count', v_like_count);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Monthly points refill (to be called by cron/scheduled function)
CREATE OR REPLACE FUNCTION monthly_points_refill()
RETURNS JSON AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    -- Update gifted_points to match monthly_points for all active users
    UPDATE users
    SET gifted_points = monthly_points,
        updated_at = NOW()
    WHERE visible = TRUE
      AND is_active = TRUE
      AND account_type = 'creator';

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    -- Update user_points last_refill
    UPDATE user_points
    SET last_refill = NOW(),
        to_give = (SELECT monthly_points FROM users WHERE users.id = user_points.user_id),
        updated_at = NOW();

    RETURN json_build_object(
        'success', true,
        'message', 'Refill mensual completado',
        'users_updated', v_updated_count
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get user's feed with likes and comments count
CREATE OR REPLACE FUNCTION get_account_feeds(
    p_account INTEGER,
    p_limit INTEGER DEFAULT 20,
    p_offset INTEGER DEFAULT 0
)
RETURNS JSON AS $$
DECLARE
    v_feeds JSON;
BEGIN
    SELECT json_agg(feed_data)
    INTO v_feeds
    FROM (
        SELECT
            af.id,
            af.header,
            af.body,
            af.footer,
            af.image,
            af.type,
            af.is_highlighted,
            af.created_at,
            json_build_object(
                'id', u.id,
                'complete_name', u.complete_name,
                'avatar', u.avatar
            ) as sender,
            (SELECT COUNT(*) FROM feed_likes WHERE feed_id = af.id) as like_count,
            (SELECT COUNT(*) FROM feed_comments WHERE feed_id = af.id) as comment_count,
            EXISTS(SELECT 1 FROM feed_likes WHERE feed_id = af.id AND user_id = auth.uid()) as user_liked
        FROM account_feeds af
        JOIN users u ON u.id = af.sender_id
        WHERE af.account = p_account
          AND af.visible = TRUE
        ORDER BY af.created_at DESC
        LIMIT p_limit
        OFFSET p_offset
    ) as feed_data;

    RETURN json_build_object('success', true, 'data', COALESCE(v_feeds, '[]'::json));
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- Get user dashboard stats
CREATE OR REPLACE FUNCTION get_user_stats(p_user_id UUID DEFAULT NULL)
RETURNS JSON AS $$
DECLARE
    v_user_id UUID;
    v_user RECORD;
    v_acknowledgments_given INTEGER;
    v_acknowledgments_received INTEGER;
    v_exchanges_count INTEGER;
BEGIN
    v_user_id := COALESCE(p_user_id, auth.uid());

    SELECT * INTO v_user FROM users WHERE id = v_user_id;
    IF v_user IS NULL THEN
        RETURN json_build_object('success', false, 'message', 'Usuario no encontrado');
    END IF;

    SELECT COUNT(*) INTO v_acknowledgments_given
    FROM acknowledgments WHERE sender_id = v_user_id;

    SELECT COUNT(*) INTO v_acknowledgments_received
    FROM acknowledgment_recipients WHERE user_id = v_user_id;

    SELECT COUNT(*) INTO v_exchanges_count
    FROM exchanges WHERE user_id = v_user_id;

    RETURN json_build_object(
        'success', true,
        'data', json_build_object(
            'points_received', v_user.points_received,
            'gifted_points', v_user.gifted_points,
            'monthly_points', v_user.monthly_points,
            'acknowledgments_given', v_acknowledgments_given,
            'acknowledgments_received', v_acknowledgments_received,
            'exchanges_count', v_exchanges_count
        )
    );
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;
