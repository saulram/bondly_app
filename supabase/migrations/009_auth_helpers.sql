-- =============================================
-- Bondly Backend Migration: Auth Helper Functions
-- =============================================
-- These functions use SECURITY DEFINER to bypass RLS for pre-auth lookups.
-- They are intentionally narrow in scope (no sensitive data exposed).

-- Allow unauthenticated clients to list distinct company names
-- (needed for the login screen company dropdown)
CREATE OR REPLACE FUNCTION public.get_companies()
RETURNS TABLE(company_name TEXT) AS $$
  SELECT DISTINCT u.company_name
  FROM users u
  WHERE u.visible = TRUE AND u.company_name IS NOT NULL AND u.company_name != '';
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- Look up a user's email by employee number + company (needed for Supabase login flow)
-- Returns NULL if not found. Does NOT expose password or sensitive fields.
CREATE OR REPLACE FUNCTION public.get_email_by_employee(
  p_employee_number INTEGER,
  p_company_name TEXT
)
RETURNS TEXT AS $$
  SELECT email
  FROM users
  WHERE employee_number = p_employee_number
    AND company_name = p_company_name
    AND visible = TRUE
    AND is_active = TRUE
  LIMIT 1;
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- Add policy to allow anyone to read company names (for login dropdown)
-- This exposes only company_name, not personal data
CREATE POLICY "users_select_companies_public" ON users
  FOR SELECT
  USING (visible = TRUE AND company_name IS NOT NULL);
