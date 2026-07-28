-- =============================================
-- Bondly Admin Panel Migration
-- =============================================

-- Admin permission types
CREATE TYPE admin_permission AS ENUM (
  'manage_users',
  'manage_badges',
  'manage_rewards',
  'manage_banners',
  'manage_ambassadors',
  'view_reports',
  'manage_zones',
  'manage_settings'
);

-- =============================================
-- Zones
-- =============================================

CREATE TABLE zones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  company_name TEXT,
  parent_zone_id UUID REFERENCES zones(id) ON DELETE SET NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_zones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  zone_id UUID NOT NULL REFERENCES zones(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, zone_id)
);

-- =============================================
-- Admin Permissions
-- =============================================

CREATE TABLE admin_permissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  permission admin_permission NOT NULL,
  granted_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, permission)
);

-- =============================================
-- RLS Policies
-- =============================================

ALTER TABLE zones ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_zones ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_permissions ENABLE ROW LEVEL SECURITY;

-- Zones: readable by admins and superAdmins
CREATE POLICY "zones_select" ON zones
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role IN ('superAdmin', 'admin')
    )
  );

CREATE POLICY "zones_insert_superadmin" ON zones
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'superAdmin')
  );

CREATE POLICY "zones_update_superadmin" ON zones
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'superAdmin')
  );

CREATE POLICY "zones_delete_superadmin" ON zones
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'superAdmin')
  );

-- User zones: admins can read, superAdmin can write
CREATE POLICY "user_zones_select" ON user_zones
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role IN ('superAdmin', 'admin')
    )
  );

CREATE POLICY "user_zones_write_superadmin" ON user_zones
  FOR ALL USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'superAdmin')
  );

-- Admin permissions: superAdmin manages, admins read own
CREATE POLICY "admin_permissions_select_own" ON admin_permissions
  FOR SELECT USING (
    user_id = auth.uid()
    OR EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'superAdmin')
  );

CREATE POLICY "admin_permissions_write_superadmin" ON admin_permissions
  FOR ALL USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'superAdmin')
  );

-- =============================================
-- Helper Functions
-- =============================================

-- Check if current user has a specific admin permission
CREATE OR REPLACE FUNCTION has_admin_permission(p_permission admin_permission)
RETURNS BOOLEAN
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_role user_role;
BEGIN
  SELECT role INTO v_role FROM users WHERE id = auth.uid();
  IF v_role = 'superAdmin' THEN
    RETURN TRUE;
  END IF;
  IF v_role != 'admin' THEN
    RETURN FALSE;
  END IF;
  RETURN EXISTS (
    SELECT 1 FROM admin_permissions
    WHERE user_id = auth.uid()
    AND permission = p_permission
  );
END;
$$;

-- Get all permissions for a user
CREATE OR REPLACE FUNCTION get_user_permissions(p_user_id UUID)
RETURNS TABLE(permission admin_permission)
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_role user_role;
BEGIN
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

-- =============================================
-- Dashboard Stats Function
-- =============================================

CREATE OR REPLACE FUNCTION get_admin_dashboard_stats()
RETURNS JSON
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_role user_role;
  v_result JSON;
BEGIN
  SELECT role INTO v_role FROM users WHERE id = auth.uid();
  IF v_role NOT IN ('superAdmin', 'admin') THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  SELECT json_build_object(
    'total_users', (SELECT COUNT(*) FROM users WHERE role = 'client'),
    'active_users', (SELECT COUNT(*) FROM users WHERE role = 'client' AND is_active = TRUE),
    'month_recognitions', (
      SELECT COUNT(*) FROM user_feed
      WHERE feed_type = 'reconocimiento'
      AND created_at >= date_trunc('month', NOW())
    ),
    'month_exchanges', (
      SELECT COUNT(*) FROM exchanges
      WHERE created_at >= date_trunc('month', NOW())
    ),
    'points_circulating', (
      SELECT COALESCE(SUM(to_give), 0) FROM user_points
    ),
    'active_badges', (
      SELECT COUNT(*) FROM badges WHERE is_active = TRUE
    ),
    'active_rewards', (
      SELECT COUNT(*) FROM rewards WHERE is_active = TRUE
    )
  ) INTO v_result;

  RETURN v_result;
END;
$$;

-- =============================================
-- Recognition Trends Function
-- =============================================

CREATE OR REPLACE FUNCTION get_recognition_trends(p_months INTEGER DEFAULT 6)
RETURNS TABLE(month TEXT, count BIGINT)
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_role user_role;
BEGIN
  SELECT role INTO v_role FROM users WHERE id = auth.uid();
  IF v_role NOT IN ('superAdmin', 'admin') THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  RETURN QUERY
    SELECT
      TO_CHAR(date_trunc('month', uf.created_at), 'YYYY-MM') AS month,
      COUNT(*) AS count
    FROM user_feed uf
    WHERE uf.feed_type = 'reconocimiento'
    AND uf.created_at >= date_trunc('month', NOW()) - ((p_months - 1) * INTERVAL '1 month')
    GROUP BY date_trunc('month', uf.created_at)
    ORDER BY date_trunc('month', uf.created_at);
END;
$$;

-- =============================================
-- Badge Usage Report
-- =============================================

CREATE OR REPLACE FUNCTION get_badge_usage_report()
RETURNS TABLE(badge_id UUID, badge_name TEXT, usage_count BIGINT)
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_role user_role;
BEGIN
  SELECT role INTO v_role FROM users WHERE id = auth.uid();
  IF v_role NOT IN ('superAdmin', 'admin') THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  RETURN QUERY
    SELECT
      b.id AS badge_id,
      b.name AS badge_name,
      COUNT(ubg.id) AS usage_count
    FROM badges b
    LEFT JOIN user_badges ubg ON b.id = ubg.badge_id
    GROUP BY b.id, b.name
    ORDER BY usage_count DESC
    LIMIT 10;
END;
$$;

-- =============================================
-- Admin Users Function
-- =============================================

CREATE OR REPLACE FUNCTION get_admin_users(
  p_zone_id UUID DEFAULT NULL,
  p_search TEXT DEFAULT NULL,
  p_limit INTEGER DEFAULT 20,
  p_offset INTEGER DEFAULT 0,
  p_role TEXT DEFAULT NULL,
  p_active BOOLEAN DEFAULT NULL
)
RETURNS TABLE(
  id UUID,
  complete_name TEXT,
  email TEXT,
  role user_role,
  is_active BOOLEAN,
  company_name TEXT,
  avatar TEXT,
  monthly_points INTEGER,
  points_received INTEGER,
  gifted_points INTEGER,
  created_at TIMESTAMPTZ,
  total_count BIGINT
)
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_role user_role;
BEGIN
  SELECT u.role INTO v_role FROM users u WHERE u.id = auth.uid();
  IF v_role NOT IN ('superAdmin', 'admin') THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  RETURN QUERY
    WITH filtered AS (
      SELECT u.*
      FROM users u
      LEFT JOIN user_zones uz ON u.id = uz.user_id
      WHERE
        (p_zone_id IS NULL OR uz.zone_id = p_zone_id)
        AND (p_search IS NULL OR u.complete_name ILIKE '%' || p_search || '%' OR u.email ILIKE '%' || p_search || '%')
        AND (p_role IS NULL OR u.role::TEXT = p_role)
        AND (p_active IS NULL OR u.is_active = p_active)
    )
    SELECT
      f.id,
      f.complete_name,
      f.email,
      f.role,
      f.is_active,
      f.company_name,
      f.avatar,
      f.monthly_points,
      f.points_received,
      f.gifted_points,
      f.created_at,
      COUNT(*) OVER() AS total_count
    FROM filtered f
    ORDER BY f.created_at DESC
    LIMIT p_limit
    OFFSET p_offset;
END;
$$;

-- =============================================
-- Update superAdmin roles for test accounts
-- =============================================

UPDATE users
SET role = 'superAdmin'
WHERE email IN (
  'saul@bondly.mx',
  'mariana@bondly.mx',
  'juan@bondly.mx',
  'saulrm9418@gmail.com'
);
