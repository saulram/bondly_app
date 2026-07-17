-- =============================================
-- Bondly: "Voz" — Suggestion Box hardening (follows 017)
-- =============================================
-- Two fixes from security review:
--  1. Non-admin submitters could set status/admin_note/visible directly via
--     PostgREST (RLS only constrained user_id/is_anonymous). A planted
--     admin_note is especially dangerous in an HR complaint box. Force safe
--     defaults for any caller that isn't a suggestion-box admin.
--  2. Admin RLS used is_admin() (JWT-claim role), so the per-module
--     `manage_suggestions` grant was UI-only — any admin could read/delete
--     confidential complaints. Move to has_admin_permission(), which reads the
--     role from the users table (guarded by 015) and honors the grant.

-- 1. Clamp attacker-controllable columns on insert for non-privileged users.
CREATE OR REPLACE FUNCTION public.enforce_suggestion_insert_defaults()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  IF NOT has_admin_permission('manage_suggestions') THEN
    NEW.status := 'nueva';
    NEW.admin_note := NULL;
    NEW.visible := TRUE;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER suggestions_enforce_insert_defaults
    BEFORE INSERT ON suggestions
    FOR EACH ROW
    EXECUTE FUNCTION public.enforce_suggestion_insert_defaults();

-- 2. Enforce the manage_suggestions grant at the DB. The FOR ALL policy also
-- covers SELECT, so the separate admin-select policy from 017 is redundant.
DROP POLICY IF EXISTS "suggestions_select_admin" ON suggestions;
DROP POLICY IF EXISTS "suggestions_manage_admin" ON suggestions;

CREATE POLICY "suggestions_manage_admin" ON suggestions
    FOR ALL
    USING (has_admin_permission('manage_suggestions'))
    WITH CHECK (has_admin_permission('manage_suggestions'));
