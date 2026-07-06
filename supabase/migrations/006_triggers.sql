-- =============================================
-- Bondly Backend Migration: Triggers
-- =============================================

-- =============================================
-- Updated At Triggers
-- =============================================

CREATE TRIGGER users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER user_points_updated_at
    BEFORE UPDATE ON user_points
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER user_balances_updated_at
    BEFORE UPDATE ON user_balances
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER badge_categories_updated_at
    BEFORE UPDATE ON badge_categories
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER badges_updated_at
    BEFORE UPDATE ON badges
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER badge_reports_updated_at
    BEFORE UPDATE ON badge_reports
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER acknowledgments_updated_at
    BEFORE UPDATE ON acknowledgments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER rewards_updated_at
    BEFORE UPDATE ON rewards
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER carts_updated_at
    BEFORE UPDATE ON carts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER cart_items_updated_at
    BEFORE UPDATE ON cart_items
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER exchanges_updated_at
    BEFORE UPDATE ON exchanges
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER account_feeds_updated_at
    BEFORE UPDATE ON account_feeds
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER activities_updated_at
    BEFORE UPDATE ON activities
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER account_statements_updated_at
    BEFORE UPDATE ON account_statements
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER ambassadors_updated_at
    BEFORE UPDATE ON ambassadors
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER banners_updated_at
    BEFORE UPDATE ON banners
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER news_updated_at
    BEFORE UPDATE ON news
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- Auth User Registration Trigger
-- =============================================

-- Function to handle new user registration
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
    v_company_name TEXT;
    v_account_number INTEGER;
    v_role user_role;
    v_account_type account_type;
    v_monthly_points INTEGER;
BEGIN
    -- Extract metadata from auth.users
    v_company_name := NEW.raw_user_meta_data ->> 'company_name';
    v_account_number := COALESCE((NEW.raw_user_meta_data ->> 'account_number')::INTEGER, 0);
    v_role := COALESCE((NEW.raw_user_meta_data ->> 'role')::user_role, 'client');
    v_account_type := COALESCE((NEW.raw_user_meta_data ->> 'account_type')::account_type, 'invitee');
    v_monthly_points := COALESCE((NEW.raw_user_meta_data ->> 'monthly_points')::INTEGER, 0);

    -- Create user record
    INSERT INTO public.users (
        id,
        email,
        complete_name,
        role,
        account_type,
        company_name,
        account_number,
        monthly_points,
        gifted_points,
        visible,
        is_active
    ) VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data ->> 'complete_name', NEW.email),
        v_role,
        v_account_type,
        v_company_name,
        v_account_number,
        v_monthly_points,
        v_monthly_points,  -- Start with gifted_points = monthly_points
        TRUE,
        TRUE
    );

    -- Create user profile
    INSERT INTO public.user_profiles (user_id, company_name, visible)
    VALUES (NEW.id, v_company_name, TRUE);

    -- Create user points tracking
    INSERT INTO public.user_points (user_id, to_give, refill_amount, last_refill)
    VALUES (NEW.id, v_monthly_points, v_monthly_points, NOW());

    -- Create shopping cart
    INSERT INTO public.carts (user_id, type, company_name, total)
    VALUES (NEW.id, 'cart', v_company_name, 0);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger on auth.users insert
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION handle_new_user();

-- =============================================
-- Cart Total Recalculation Trigger
-- =============================================

CREATE OR REPLACE FUNCTION recalculate_cart_total()
RETURNS TRIGGER AS $$
DECLARE
    v_cart_id UUID;
    v_new_total INTEGER;
BEGIN
    -- Get cart_id from the affected row
    IF TG_OP = 'DELETE' THEN
        v_cart_id := OLD.cart_id;
    ELSE
        v_cart_id := NEW.cart_id;
    END IF;

    -- Recalculate total
    SELECT COALESCE(SUM(ci.quantity * r.points), 0)
    INTO v_new_total
    FROM cart_items ci
    JOIN rewards r ON r.id = ci.reward_id
    WHERE ci.cart_id = v_cart_id;

    -- Update cart
    UPDATE carts SET total = v_new_total, updated_at = NOW()
    WHERE id = v_cart_id;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER cart_items_recalculate_total
    AFTER INSERT OR UPDATE OR DELETE ON cart_items
    FOR EACH ROW
    EXECUTE FUNCTION recalculate_cart_total();

-- =============================================
-- User Profile Auto-Ambassador Sync
-- =============================================

CREATE OR REPLACE FUNCTION sync_ambassador_status()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- When adding ambassador, update user profile
        UPDATE user_profiles
        SET is_ambassador = TRUE,
            updated_at = NOW()
        WHERE user_id = NEW.user_id;
    ELSIF TG_OP = 'DELETE' OR (TG_OP = 'UPDATE' AND NEW.visible = FALSE) THEN
        -- When removing ambassador, update user profile
        UPDATE user_profiles
        SET is_ambassador = FALSE,
            ambassador_title = NULL,
            updated_at = NOW()
        WHERE user_id = COALESCE(NEW.user_id, OLD.user_id);
    END IF;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ambassadors_sync_profile
    AFTER INSERT OR UPDATE OR DELETE ON ambassadors
    FOR EACH ROW
    EXECUTE FUNCTION sync_ambassador_status();

-- =============================================
-- Activity Creation on Acknowledgment
-- =============================================

CREATE OR REPLACE FUNCTION create_activity_on_acknowledgment()
RETURNS TRIGGER AS $$
DECLARE
    v_sender RECORD;
    v_badge RECORD;
BEGIN
    -- Get sender info
    SELECT * INTO v_sender FROM users WHERE id = NEW.sender_id;

    -- Get badge info
    SELECT * INTO v_badge FROM badges WHERE id = NEW.badge_id;

    -- Create activity for acknowledgment
    INSERT INTO activities (user_id, title, content, read, company_name)
    VALUES (
        NEW.sender_id,
        'Reconocimiento enviado',
        'Enviaste el reconocimiento "' || v_badge.name || '"',
        TRUE,  -- Sender's own activity is auto-read
        v_sender.company_name
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER acknowledgments_create_activity
    AFTER INSERT ON acknowledgments
    FOR EACH ROW
    EXECUTE FUNCTION create_activity_on_acknowledgment();

-- =============================================
-- Activity Creation on Acknowledgment Recipient
-- =============================================

CREATE OR REPLACE FUNCTION create_activity_for_recipient()
RETURNS TRIGGER AS $$
DECLARE
    v_acknowledgment RECORD;
    v_sender RECORD;
    v_badge RECORD;
    v_recipient RECORD;
BEGIN
    -- Get acknowledgment info
    SELECT * INTO v_acknowledgment FROM acknowledgments WHERE id = NEW.acknowledgment_id;

    -- Get sender info
    SELECT * INTO v_sender FROM users WHERE id = v_acknowledgment.sender_id;

    -- Get badge info
    SELECT * INTO v_badge FROM badges WHERE id = v_acknowledgment.badge_id;

    -- Get recipient info
    SELECT * INTO v_recipient FROM users WHERE id = NEW.user_id;

    -- Create activity for recipient
    INSERT INTO activities (user_id, title, content, read, company_name)
    VALUES (
        NEW.user_id,
        'Nuevo reconocimiento',
        v_sender.complete_name || ' te envió el reconocimiento "' || v_badge.name || '"',
        FALSE,
        v_recipient.company_name
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER acknowledgment_recipients_create_activity
    AFTER INSERT ON acknowledgment_recipients
    FOR EACH ROW
    EXECUTE FUNCTION create_activity_for_recipient();

-- =============================================
-- Exchange Status Change Activity
-- =============================================

CREATE OR REPLACE FUNCTION create_activity_on_exchange_status()
RETURNS TRIGGER AS $$
DECLARE
    v_reward RECORD;
    v_user RECORD;
BEGIN
    -- Only trigger on status change
    IF OLD.status = NEW.status THEN
        RETURN NEW;
    END IF;

    -- Get reward info
    SELECT * INTO v_reward FROM rewards WHERE id = NEW.reward_id;

    -- Get user info
    SELECT * INTO v_user FROM users WHERE id = NEW.user_id;

    -- Create activity for status change
    INSERT INTO activities (user_id, title, content, read, company_name)
    VALUES (
        NEW.user_id,
        'Estado de canje actualizado',
        'Tu canje de "' || v_reward.name || '" cambió a: ' || NEW.status,
        FALSE,
        v_user.company_name
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER exchanges_status_activity
    AFTER UPDATE ON exchanges
    FOR EACH ROW
    EXECUTE FUNCTION create_activity_on_exchange_status();

-- =============================================
-- Soft Delete Cascade (when visible = false)
-- =============================================

CREATE OR REPLACE FUNCTION handle_user_soft_delete()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.visible = FALSE AND OLD.visible = TRUE THEN
        -- Soft delete related records
        UPDATE user_profiles SET visible = FALSE WHERE user_id = NEW.id;
        UPDATE acknowledgments SET visible = FALSE WHERE sender_id = NEW.id;
        UPDATE ambassadors SET visible = FALSE WHERE user_id = NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_soft_delete_cascade
    AFTER UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION handle_user_soft_delete();
