-- =============================================
-- Bondly Backend Migration: Auth Helper Functions
-- =============================================
-- Single-tenant deployment: each Supabase project belongs to ONE company.
-- company_name is kept as metadata/display field but not used for data isolation.
-- These functions use SECURITY DEFINER to bypass RLS for pre-auth lookups.

-- Look up a user's email by employee number (no company filter — single-tenant).
-- Returns NULL if not found. Does NOT expose password or sensitive fields.
CREATE OR REPLACE FUNCTION public.get_email_by_employee(
  p_employee_number INTEGER
)
RETURNS TEXT AS $$
  SELECT email
  FROM users
  WHERE employee_number = p_employee_number
    AND visible = TRUE
    AND is_active = TRUE
  LIMIT 1;
$$ LANGUAGE SQL STABLE SECURITY DEFINER;
