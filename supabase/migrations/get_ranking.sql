-- ============================================================
-- RPC: get_ranking
-- Returns the top N users ranked by recognition count
-- filtered by period (month, quarter, year).
--
-- Usage from Supabase client:
--   .rpc('get_ranking', { 'period_filter': 'month', 'result_limit': 10 })
-- ============================================================

CREATE OR REPLACE FUNCTION get_ranking(
  period_filter text DEFAULT 'month',
  result_limit int DEFAULT 10
)
RETURNS TABLE (
  position bigint,
  user_id uuid,
  complete_name text,
  avatar text,
  job_position text,
  recognition_count bigint
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    ROW_NUMBER() OVER (ORDER BY COUNT(ar.id) DESC) AS position,
    u.id AS user_id,
    u.complete_name,
    u.avatar,
    up.job_position,
    COUNT(ar.id) AS recognition_count
  FROM acknowledgment_recipients ar
  INNER JOIN acknowledgments a ON a.id = ar.acknowledgment_id
  INNER JOIN users u ON u.id = ar.user_id
  LEFT JOIN user_profiles up ON up.user_id = u.id
  WHERE u.visible = true
    AND u.is_active = true
    AND a.visible = true
    AND (
      CASE
        WHEN period_filter = 'month' THEN a.created_at >= date_trunc('month', now())
        WHEN period_filter = 'quarter' THEN a.created_at >= date_trunc('quarter', now())
        WHEN period_filter = 'year' THEN a.created_at >= date_trunc('year', now())
        ELSE true
      END
    )
  GROUP BY u.id, u.complete_name, u.avatar, up.job_position
  ORDER BY recognition_count DESC
  LIMIT result_limit;
END;
$$ LANGUAGE plpgsql;
