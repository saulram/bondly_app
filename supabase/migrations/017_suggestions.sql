-- =============================================
-- Bondly: "Voz" — Suggestion Box (Buzón de Sugerencias)
-- =============================================
-- Collaborators submit suggestions/inquiries, optionally anonymous.
-- Admins triage them (status + internal note). Single-tenant RLS model (see 011).

-- Lifecycle of a suggestion
CREATE TYPE suggestion_status AS ENUM ('nueva', 'en_revision', 'resuelta', 'archivada');

CREATE TABLE suggestions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    -- Author. NULL when the suggestion is anonymous (identity is never stored).
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    is_anonymous BOOLEAN NOT NULL DEFAULT FALSE,
    category TEXT,
    title TEXT,
    message TEXT NOT NULL,
    status suggestion_status NOT NULL DEFAULT 'nueva',
    -- Internal admin note / response (never exposed to the author).
    admin_note TEXT,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_suggestions_status ON suggestions(status);
CREATE INDEX idx_suggestions_created_at ON suggestions(created_at DESC);
CREATE INDEX idx_suggestions_user_id ON suggestions(user_id);

-- Keep updated_at fresh
CREATE TRIGGER suggestions_updated_at
    BEFORE UPDATE ON suggestions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- RLS
-- =============================================
ALTER TABLE suggestions ENABLE ROW LEVEL SECURITY;

-- Any authenticated user can submit. An anonymous suggestion must NOT carry an
-- author id; a signed suggestion must carry the submitter's own id (no spoofing).
CREATE POLICY "suggestions_insert_own" ON suggestions
    FOR INSERT
    WITH CHECK (
        auth.uid() IS NOT NULL AND (
            (is_anonymous AND user_id IS NULL) OR
            (NOT is_anonymous AND user_id = auth.uid())
        )
    );

-- Only admins can read the raw table (it holds admin_note, an internal field).
-- Authors read their own suggestions through get_my_suggestions() below, which
-- deliberately omits admin_note. Anonymous rows (user_id = NULL) are never
-- returned to any client.
CREATE POLICY "suggestions_select_admin" ON suggestions
    FOR SELECT USING (public.is_admin());

-- Admins manage everything (triage status, add notes, archive).
CREATE POLICY "suggestions_manage_admin" ON suggestions
    FOR ALL USING (public.is_admin());

-- Author-facing read path. SECURITY DEFINER so it bypasses the admin-only SELECT
-- policy, but it hard-filters to the caller's own non-anonymous rows and never
-- exposes admin_note.
CREATE OR REPLACE FUNCTION public.get_my_suggestions()
RETURNS TABLE (
    id UUID,
    title TEXT,
    category TEXT,
    message TEXT,
    status suggestion_status,
    is_anonymous BOOLEAN,
    created_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT s.id, s.title, s.category, s.message, s.status, s.is_anonymous,
           s.created_at
    FROM suggestions s
    WHERE s.user_id = auth.uid()
      AND s.is_anonymous = FALSE
      AND s.visible = TRUE
    ORDER BY s.created_at DESC;
$$;

GRANT EXECUTE ON FUNCTION public.get_my_suggestions() TO authenticated;

-- New admin module for the suggestion box. Safe with IF NOT EXISTS; value is not
-- referenced elsewhere in this migration, so no in-transaction enum-use conflict.
ALTER TYPE admin_permission ADD VALUE IF NOT EXISTS 'manage_suggestions';
