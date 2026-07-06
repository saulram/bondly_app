-- =============================================
-- Migration 016: Lock down the point economy against client tampering
-- =============================================
-- Security review found that a normal `client`, using the anon PostgREST
-- endpoint + their own JWT, could rewrite the reward economy directly:
--
--   1. users_update_own granted UPDATE on the WHOLE users row, so a client
--      could set points_received / gifted_points / monthly_points to any
--      value → unlimited reward redemptions (checkout_cart reads
--      users.points_received) and unlimited recognitions (create_acknowledgment
--      reads users.gifted_points).
--   2. exchanges_insert let clients INSERT fully-formed redemption rows,
--      bypassing checkout_cart's point deduction entirely.
--   3. user_points_update_own let clients rewrite their own to_give/earned.
--
-- The legitimate point mutations happen inside SECURITY DEFINER functions
-- (checkout_cart, create_acknowledgment, monthly_points_refill). Inside a
-- SECURITY DEFINER function auth.uid() still returns the *calling* user, so a
-- naive "block unless is_admin()" trigger would also block those functions'
-- own deductions. But `current_user` DOES change: inside a definer function it
-- is the function owner (postgres), and for a direct PostgREST write it is
-- `authenticated`/`anon`. We gate on that — it needs no GUCs and no changes to
-- the economy functions themselves.

-- =============================================
-- 1. Guard economic / privilege columns on `users`
-- =============================================
-- SECURITY INVOKER (default) so current_user reflects the real caller context.

CREATE OR REPLACE FUNCTION public.guard_user_economy_columns()
RETURNS TRIGGER AS $$
BEGIN
    -- Trusted contexts: SECURITY DEFINER economy functions (current_user =
    -- owner), the service role, and admins acting through the panel.
    IF current_user NOT IN ('authenticated', 'anon')
       OR public.is_admin()
    THEN
        RETURN NEW;
    END IF;

    IF NEW.points_received IS DISTINCT FROM OLD.points_received
       OR NEW.gifted_points   IS DISTINCT FROM OLD.gifted_points
       OR NEW.monthly_points  IS DISTINCT FROM OLD.monthly_points
       OR NEW.is_active       IS DISTINCT FROM OLD.is_active
       OR NEW.employee_number IS DISTINCT FROM OLD.employee_number
       OR NEW.account_number  IS DISTINCT FROM OLD.account_number
       OR NEW.account_holder  IS DISTINCT FROM OLD.account_holder
       OR NEW.seats           IS DISTINCT FROM OLD.seats
       OR NEW.plan_type       IS DISTINCT FROM OLD.plan_type
       OR NEW.visible         IS DISTINCT FROM OLD.visible
    THEN
        RAISE EXCEPTION 'No autorizado para modificar campos administrativos del usuario';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS users_guard_economy_columns ON users;
CREATE TRIGGER users_guard_economy_columns
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION public.guard_user_economy_columns();

-- =============================================
-- 2. exchanges: no direct client inserts
-- =============================================
-- Redemptions must go through checkout_cart() (SECURITY DEFINER, deducts
-- points, bypasses RLS as owner). Admins may still create exchanges manually.

DROP POLICY IF EXISTS "exchanges_insert" ON exchanges;
DROP POLICY IF EXISTS "exchanges_insert_admin" ON exchanges;
CREATE POLICY "exchanges_insert_admin" ON exchanges
    FOR INSERT WITH CHECK (public.is_admin());

-- =============================================
-- 3. user_points: writes are admin/server only
-- =============================================
-- Was: USING (user_id = auth.uid() OR public.is_admin()) with no WITH CHECK,
-- letting clients rewrite their own ledger. monthly_points_refill writes it as
-- SECURITY DEFINER (owner) and bypasses RLS, so refills are unaffected.

DROP POLICY IF EXISTS "user_points_update_own" ON user_points;
DROP POLICY IF EXISTS "user_points_update_admin" ON user_points;
CREATE POLICY "user_points_update_admin" ON user_points
    FOR UPDATE
    USING (public.is_admin())
    WITH CHECK (public.is_admin());
