-- =============================================
-- Bondly: Single-Tenant RLS Simplification
-- =============================================
-- Each Supabase instance is deployed for ONE company (one flavor per client).
-- company_name filtering in policies is redundant — all DB users belong to the same org.
-- This migration drops the multi-tenant company-filter policies and replaces them
-- with simple auth-only policies.

-- =============================================
-- Drop old multi-tenant policies
-- =============================================

DROP POLICY IF EXISTS "users_select_company"            ON users;
DROP POLICY IF EXISTS "users_update_admin"              ON users;
DROP POLICY IF EXISTS "user_profiles_select_company"    ON user_profiles;
DROP POLICY IF EXISTS "user_profiles_update_admin"      ON user_profiles;
DROP POLICY IF EXISTS "badge_categories_select_company" ON badge_categories;
DROP POLICY IF EXISTS "badge_categories_update_admin"   ON badge_categories;
DROP POLICY IF EXISTS "badge_categories_delete_admin"   ON badge_categories;
DROP POLICY IF EXISTS "badges_select_company"           ON badges;
DROP POLICY IF EXISTS "acknowledgments_select_account"  ON acknowledgments;
DROP POLICY IF EXISTS "rewards_select_company"          ON rewards;
DROP POLICY IF EXISTS "rewards_select_admin"            ON rewards;
DROP POLICY IF EXISTS "rewards_update_admin"            ON rewards;
DROP POLICY IF EXISTS "rewards_delete_admin"            ON rewards;
DROP POLICY IF EXISTS "exchanges_select_own"            ON exchanges;
DROP POLICY IF EXISTS "exchanges_update_admin"          ON exchanges;
DROP POLICY IF EXISTS "account_feeds_select_account"    ON account_feeds;
DROP POLICY IF EXISTS "account_feeds_update_admin"      ON account_feeds;
DROP POLICY IF EXISTS "ambassadors_select_company"      ON ambassadors;
DROP POLICY IF EXISTS "ambassadors_insert_admin"        ON ambassadors;
DROP POLICY IF EXISTS "ambassadors_update_admin"        ON ambassadors;
DROP POLICY IF EXISTS "ambassadors_delete_admin"        ON ambassadors;
DROP POLICY IF EXISTS "banners_select_company"          ON banners;
DROP POLICY IF EXISTS "banners_select_admin"            ON banners;
DROP POLICY IF EXISTS "banners_insert_admin"            ON banners;
DROP POLICY IF EXISTS "banners_update_admin"            ON banners;
DROP POLICY IF EXISTS "banners_delete_admin"            ON banners;
DROP POLICY IF EXISTS "news_select_admin"               ON news;
DROP POLICY IF EXISTS "news_insert_admin"               ON news;
DROP POLICY IF EXISTS "news_update_admin"               ON news;
DROP POLICY IF EXISTS "news_delete_admin"               ON news;
DROP POLICY IF EXISTS "acknowledgment_recipients_select" ON acknowledgment_recipients;

-- =============================================
-- Single-tenant replacement policies
-- =============================================

-- USERS: any authenticated user can read all users in this instance
CREATE POLICY "users_select_authenticated" ON users
    FOR SELECT USING (auth.uid() IS NOT NULL);

-- Admins can update any user
CREATE POLICY "users_update_admin" ON users
    FOR UPDATE
    USING (public.is_admin())
    WITH CHECK (public.is_admin());

-- USER PROFILES: any authenticated user can read all profiles
CREATE POLICY "user_profiles_select_authenticated" ON user_profiles
    FOR SELECT USING (auth.uid() IS NOT NULL);

-- Admins can update any profile
CREATE POLICY "user_profiles_update_admin" ON user_profiles
    FOR UPDATE USING (public.is_admin());

-- BADGE CATEGORIES: any authenticated user can read
CREATE POLICY "badge_categories_select_authenticated" ON badge_categories
    FOR SELECT USING (auth.uid() IS NOT NULL AND visible = TRUE);

-- Admins manage badge categories
CREATE POLICY "badge_categories_manage_admin" ON badge_categories
    FOR ALL USING (public.is_admin());

-- BADGES: any authenticated user can read active badges
CREATE POLICY "badges_select_authenticated" ON badges
    FOR SELECT USING (auth.uid() IS NOT NULL AND visible = TRUE);

-- ACKNOWLEDGMENTS: any authenticated user can read all
CREATE POLICY "acknowledgments_select_authenticated" ON acknowledgments
    FOR SELECT USING (auth.uid() IS NOT NULL AND visible = TRUE);

-- ACKNOWLEDGMENT RECIPIENTS: user can see own, or all if authenticated
CREATE POLICY "acknowledgment_recipients_select_authenticated" ON acknowledgment_recipients
    FOR SELECT
    USING (
        user_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM acknowledgments
            WHERE acknowledgments.id = acknowledgment_recipients.acknowledgment_id
        )
    );

-- REWARDS: any authenticated user can read enabled rewards
CREATE POLICY "rewards_select_authenticated" ON rewards
    FOR SELECT USING (auth.uid() IS NOT NULL AND visible = TRUE AND enable = TRUE);

-- Admins manage rewards
CREATE POLICY "rewards_manage_admin" ON rewards
    FOR ALL USING (public.is_admin());

-- EXCHANGES: users see own exchanges, admins see all
CREATE POLICY "exchanges_select_own_or_admin" ON exchanges
    FOR SELECT USING (user_id = auth.uid() OR public.is_admin());

-- Admins update exchanges (status changes)
CREATE POLICY "exchanges_update_admin" ON exchanges
    FOR UPDATE USING (public.is_admin());

-- ACCOUNT FEEDS: any authenticated user can read visible feeds
CREATE POLICY "account_feeds_select_authenticated" ON account_feeds
    FOR SELECT USING (auth.uid() IS NOT NULL AND visible = TRUE);

-- Admins can update/delete feeds
CREATE POLICY "account_feeds_manage_admin" ON account_feeds
    FOR ALL USING (public.is_admin());

-- AMBASSADORS: any authenticated user can read
CREATE POLICY "ambassadors_select_authenticated" ON ambassadors
    FOR SELECT USING (auth.uid() IS NOT NULL AND visible = TRUE);

-- Admins manage ambassadors
CREATE POLICY "ambassadors_manage_admin" ON ambassadors
    FOR ALL USING (public.is_admin());

-- BANNERS: any authenticated user can read active banners
CREATE POLICY "banners_select_authenticated" ON banners
    FOR SELECT USING (auth.uid() IS NOT NULL AND visible = TRUE AND is_active = TRUE);

-- Admins manage banners
CREATE POLICY "banners_manage_admin" ON banners
    FOR ALL USING (public.is_admin());

-- NEWS: any authenticated user can read visible, non-hidden news
CREATE POLICY "news_select_authenticated" ON news
    FOR SELECT USING (auth.uid() IS NOT NULL AND visible = TRUE AND hidden = FALSE);

-- Admins manage news
CREATE POLICY "news_manage_admin" ON news
    FOR ALL USING (public.is_admin());

-- =============================================
-- Remove unused helper functions from 004
-- (get_user_company / get_user_account no longer needed for RLS)
-- =============================================

DROP FUNCTION IF EXISTS public.get_user_company();
DROP FUNCTION IF EXISTS public.get_user_account();
