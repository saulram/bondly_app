-- =============================================
-- Migration 015: Admin panel hardening
-- =============================================
-- 1. New permission: feed/recognition moderation module
-- 2. RLS gaps: admins couldn't see hidden badges/acknowledgments,
--    nor moderate comments/likes, nor assign zones
-- 3. Role escalation guard: only superAdmin can touch superAdmin roles
-- 4. get_user_permissions: restrict to self-or-admin
--
-- Note: replaces the old (never-applied) create_admin_user RPC approach.
-- User creation now goes through the admin-create-user Edge Function,
-- which uses GoTrue's admin API + the on_auth_user_created trigger.

DROP FUNCTION IF EXISTS create_admin_user(TEXT, TEXT, TEXT, INT);

-- New admin permission for feed moderation (unusable in this transaction, only referenced at runtime)
ALTER TYPE admin_permission ADD VALUE IF NOT EXISTS 'manage_feeds';

-- =============================================
-- RLS gaps
-- =============================================

-- Admins can list hidden/invisible badges (management view)
CREATE POLICY "badges_select_admin" ON badges
    FOR SELECT USING (public.is_admin());

-- Admins fully manage acknowledgments (see hidden, hide, delete)
CREATE POLICY "acknowledgments_manage_admin" ON acknowledgments
    FOR ALL USING (public.is_admin());

-- Admins can read comments of any feed (incl. hidden feeds)
CREATE POLICY "feed_comments_select_admin" ON feed_comments
    FOR SELECT USING (public.is_admin());

-- Admin moderation deletes on likes
CREATE POLICY "feed_likes_delete_admin" ON feed_likes
    FOR DELETE USING (public.is_admin());

CREATE POLICY "reward_likes_delete_admin" ON reward_likes
    FOR DELETE USING (public.is_admin());

-- Admin visibility for support on user-scoped tables
CREATE POLICY "user_notifications_select_admin" ON user_notifications
    FOR SELECT USING (public.is_admin());

CREATE POLICY "user_notifications_delete_admin" ON user_notifications
    FOR DELETE USING (public.is_admin());

CREATE POLICY "carts_select_admin" ON carts
    FOR SELECT USING (public.is_admin());

CREATE POLICY "cart_items_select_admin" ON cart_items
    FOR SELECT USING (public.is_admin());

-- Zone assignment was superAdmin-only; admins manage users, so they
-- also manage user-zone assignments (single-tenant instance)
DROP POLICY IF EXISTS "user_zones_write_superadmin" ON user_zones;
CREATE POLICY "user_zones_write_admin" ON user_zones
    FOR ALL USING (public.is_admin())
    WITH CHECK (public.is_admin());

-- =============================================
-- Role escalation guard
-- =============================================
-- users_update_admin lets any admin UPDATE users, including role.
-- Without this trigger an admin could promote themselves to superAdmin.

CREATE OR REPLACE FUNCTION public.guard_role_change()
RETURNS TRIGGER AS $$
BEGIN
    -- Service-role / backend jobs (no auth context) are exempt
    IF auth.uid() IS NULL THEN
        RETURN NEW;
    END IF;
    IF public.get_user_role() = 'superAdmin' THEN
        RETURN NEW;
    END IF;
    IF NEW.role = 'superAdmin' OR OLD.role = 'superAdmin' THEN
        RAISE EXCEPTION 'Solo un superAdmin puede modificar roles de superAdmin';
    END IF;
    IF NOT public.is_admin() THEN
        RAISE EXCEPTION 'No autorizado para cambiar roles';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS users_guard_role_change ON users;
CREATE TRIGGER users_guard_role_change
    BEFORE UPDATE OF role ON users
    FOR EACH ROW
    WHEN (OLD.role IS DISTINCT FROM NEW.role)
    EXECUTE FUNCTION public.guard_role_change();

-- =============================================
-- get_user_permissions: only self or admins may query
-- =============================================

CREATE OR REPLACE FUNCTION get_user_permissions(p_user_id UUID)
RETURNS TABLE(permission admin_permission)
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_role user_role;
BEGIN
  IF auth.uid() IS DISTINCT FROM p_user_id AND NOT public.is_admin() THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  SELECT role INTO v_role FROM users WHERE id = p_user_id;
  IF v_role = 'superAdmin' THEN
    RETURN QUERY
      SELECT unnest(ENUM_RANGE(NULL::admin_permission));
    RETURN;
  END IF;
  RETURN QUERY
    SELECT ap.permission FROM admin_permissions ap WHERE ap.user_id = p_user_id;
END;
$$;
