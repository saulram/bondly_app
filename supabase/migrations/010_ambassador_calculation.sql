-- =============================================
-- Bondly Backend Migration: Ambassador Calculation
-- =============================================
-- Monthly cron job logic to determine ambassadors per badge.
-- Algorithm: For each badge, the user who received it most in the prior
-- calendar month is named ambassador — only if there's a single winner (no ties).

CREATE OR REPLACE FUNCTION calculate_monthly_ambassadors()
RETURNS JSON AS $$
DECLARE
    v_prev_month_start TIMESTAMPTZ;
    v_prev_month_end TIMESTAMPTZ;
    v_badge RECORD;
    v_winner RECORD;
    v_winner_count BIGINT;
    v_runner_up_count BIGINT;
    v_new_ambassador_id UUID;
    v_feed_id UUID;
    v_user RECORD;
    v_ambassadors_created INTEGER := 0;
BEGIN
    -- Calculate previous calendar month range
    v_prev_month_start := date_trunc('month', NOW() - INTERVAL '1 month');
    v_prev_month_end   := date_trunc('month', NOW());

    -- Iterate over all active badges
    FOR v_badge IN
        SELECT id FROM badges WHERE visible = TRUE AND is_active = TRUE
    LOOP
        -- Count recognitions per recipient for this badge in the previous month
        SELECT
            ar.user_id,
            COUNT(*) AS cnt
        INTO v_winner
        FROM acknowledgment_recipients ar
        JOIN acknowledgments a ON a.id = ar.acknowledgment_id
        WHERE a.badge_id = v_badge.id
          AND a.visible = TRUE
          AND a.created_at >= v_prev_month_start
          AND a.created_at <  v_prev_month_end
        GROUP BY ar.user_id
        ORDER BY cnt DESC
        LIMIT 1;

        -- Skip if no recognitions were given for this badge
        IF v_winner IS NULL THEN
            CONTINUE;
        END IF;

        v_winner_count := v_winner.cnt;

        -- Check for a tie (runner-up with same count)
        SELECT COUNT(*) INTO v_runner_up_count
        FROM (
            SELECT ar.user_id, COUNT(*) AS cnt
            FROM acknowledgment_recipients ar
            JOIN acknowledgments a ON a.id = ar.acknowledgment_id
            WHERE a.badge_id = v_badge.id
              AND a.visible = TRUE
              AND a.created_at >= v_prev_month_start
              AND a.created_at <  v_prev_month_end
            GROUP BY ar.user_id
            HAVING COUNT(*) = v_winner_count
        ) tied_users;

        -- Only create ambassador if there's exactly one winner (no ties)
        IF v_runner_up_count > 1 THEN
            CONTINUE;
        END IF;

        -- Get user info for the winner
        SELECT * INTO v_user FROM users WHERE id = v_winner.user_id;
        IF v_user IS NULL THEN CONTINUE; END IF;

        -- Create Ambassador record
        INSERT INTO ambassadors (user_id, badge_id, date, visible)
        VALUES (v_winner.user_id, v_badge.id, NOW(), TRUE)
        RETURNING id INTO v_new_ambassador_id;

        -- Create Feed entry
        INSERT INTO account_feeds (account, header, body, sender_id, type, visible)
        VALUES (
            v_user.account_number,
            v_user.complete_name || ' ha sido nombrado embajador',
            'Reconocimiento mensual por desempeño destacado',
            v_winner.user_id,
            'reconocimiento',
            TRUE
        )
        RETURNING id INTO v_feed_id;

        -- Create Activity notification for the new ambassador
        INSERT INTO activities (user_id, title, content, read, company_name, feed_id)
        VALUES (
            v_winner.user_id,
            'Has recibido una embajada',
            'Has sido nombrado embajador del mes por tus reconocimientos',
            FALSE,
            v_user.company_name,
            v_feed_id
        );

        v_ambassadors_created := v_ambassadors_created + 1;
    END LOOP;

    RETURN json_build_object(
        'success', true,
        'message', 'Cálculo de embajadores completado',
        'ambassadors_created', v_ambassadors_created,
        'period', v_prev_month_start::TEXT
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================
-- pg_cron schedule (run after ambassador cron is enabled)
-- =============================================
-- Enable pg_cron in Supabase Dashboard (Database > Extensions > pg_cron), then run:
--
-- SELECT cron.schedule(
--   'monthly-ambassador-calculation',
--   '0 0 1 * *',
--   $$SELECT calculate_monthly_ambassadors();$$
-- );
--
-- SELECT cron.schedule(
--   'monthly-points-refill',
--   '0 0 1 * *',
--   $$SELECT monthly_points_refill();$$
-- );
