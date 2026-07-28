-- =============================================
-- Fix admin dashboard functions: correct table names
-- account_feeds (not user_feed), badge_reports (not user_badges)
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
    'total_users',         (SELECT COUNT(*) FROM users WHERE role = 'client'),
    'active_users',        (SELECT COUNT(*) FROM users WHERE role = 'client' AND is_active = TRUE),
    'month_recognitions',  (
      SELECT COUNT(*) FROM account_feeds
      WHERE type = 'reconocimiento'
      AND created_at >= date_trunc('month', NOW())
    ),
    'month_exchanges',     (
      SELECT COUNT(*) FROM exchanges
      WHERE created_at >= date_trunc('month', NOW())
    ),
    'points_circulating',  (
      SELECT COALESCE(SUM(to_give), 0) FROM user_points
    ),
    'active_badges',       (SELECT COUNT(*) FROM badges  WHERE is_active = TRUE),
    'active_rewards',      (SELECT COUNT(*) FROM rewards WHERE enable  = TRUE AND visible = TRUE)
  ) INTO v_result;

  RETURN v_result;
END;
$$;

-- =============================================
-- Fix recognition trends: account_feeds, type column
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
      TO_CHAR(date_trunc('month', af.created_at), 'YYYY-MM') AS month,
      COUNT(*) AS count
    FROM account_feeds af
    WHERE af.type = 'reconocimiento'
      AND af.created_at >= date_trunc('month', NOW())
                         - ((p_months - 1) * INTERVAL '1 month')
    GROUP BY date_trunc('month', af.created_at)
    ORDER BY date_trunc('month', af.created_at);
END;
$$;

-- =============================================
-- Fix badge usage report: badge_reports table
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
      b.id   AS badge_id,
      b.name AS badge_name,
      COUNT(br.id) AS usage_count
    FROM badges b
    LEFT JOIN badge_reports br ON b.id = br.badge_id
    GROUP BY b.id, b.name
    ORDER BY usage_count DESC
    LIMIT 10;
END;
$$;
