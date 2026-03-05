-- =============================================
-- Bondly Backend Migration: Row Level Security
-- =============================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_balances ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_rewards ENABLE ROW LEVEL SECURITY;
ALTER TABLE badge_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE badge_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE acknowledgments ENABLE ROW LEVEL SECURITY;
ALTER TABLE acknowledgment_recipients ENABLE ROW LEVEL SECURITY;
ALTER TABLE rewards ENABLE ROW LEVEL SECURITY;
ALTER TABLE reward_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE carts ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE exchanges ENABLE ROW LEVEL SECURITY;
ALTER TABLE account_feeds ENABLE ROW LEVEL SECURITY;
ALTER TABLE feed_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE feed_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE account_statements ENABLE ROW LEVEL SECURITY;
ALTER TABLE statement_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ambassadors ENABLE ROW LEVEL SECURITY;
ALTER TABLE banners ENABLE ROW LEVEL SECURITY;
ALTER TABLE news ENABLE ROW LEVEL SECURITY;

-- =============================================
-- Users Table Policies
-- =============================================

-- Users can read users in same company
CREATE POLICY "users_select_company" ON users
    FOR SELECT
    USING (company_name = public.get_user_company() OR public.get_user_role() = 'superAdmin');

-- Users can update their own record
CREATE POLICY "users_update_own" ON users
    FOR UPDATE
    USING (id = auth.uid())
    WITH CHECK (id = auth.uid());

-- Admins can update users in their company
CREATE POLICY "users_update_admin" ON users
    FOR UPDATE
    USING (public.is_admin() AND company_name = public.get_user_company())
    WITH CHECK (public.is_admin() AND company_name = public.get_user_company());

-- SuperAdmin can insert users
CREATE POLICY "users_insert_superadmin" ON users
    FOR INSERT
    WITH CHECK (public.get_user_role() = 'superAdmin');

-- Admins can insert users in their company
CREATE POLICY "users_insert_admin" ON users
    FOR INSERT
    WITH CHECK (public.is_admin());

-- =============================================
-- User Profiles Policies
-- =============================================

CREATE POLICY "user_profiles_select_company" ON user_profiles
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE users.id = user_profiles.user_id
            AND (users.company_name = public.get_user_company() OR public.get_user_role() = 'superAdmin')
        )
    );

CREATE POLICY "user_profiles_update_own" ON user_profiles
    FOR UPDATE
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "user_profiles_update_admin" ON user_profiles
    FOR UPDATE
    USING (
        public.is_admin() AND EXISTS (
            SELECT 1 FROM users
            WHERE users.id = user_profiles.user_id
            AND users.company_name = public.get_user_company()
        )
    );

CREATE POLICY "user_profiles_insert" ON user_profiles
    FOR INSERT
    WITH CHECK (user_id = auth.uid() OR public.is_admin());

-- =============================================
-- User Points Policies
-- =============================================

CREATE POLICY "user_points_select_own" ON user_points
    FOR SELECT
    USING (user_id = auth.uid() OR public.is_admin());

CREATE POLICY "user_points_update_own" ON user_points
    FOR UPDATE
    USING (user_id = auth.uid() OR public.is_admin());

-- =============================================
-- User Balances Policies
-- =============================================

CREATE POLICY "user_balances_select_own" ON user_balances
    FOR SELECT
    USING (user_id = auth.uid() OR public.is_admin());

-- =============================================
-- User Logs Policies
-- =============================================

CREATE POLICY "user_logs_select_own" ON user_logs
    FOR SELECT
    USING (user_id = auth.uid() OR public.is_admin());

CREATE POLICY "user_logs_insert_own" ON user_logs
    FOR INSERT
    WITH CHECK (user_id = auth.uid());

-- =============================================
-- User Notifications Policies
-- =============================================

CREATE POLICY "user_notifications_select_own" ON user_notifications
    FOR SELECT
    USING (user_id = auth.uid());

CREATE POLICY "user_notifications_insert" ON user_notifications
    FOR INSERT
    WITH CHECK (user_id = auth.uid() OR public.is_admin());

CREATE POLICY "user_notifications_update_own" ON user_notifications
    FOR UPDATE
    USING (user_id = auth.uid());

-- =============================================
-- User Rewards Policies
-- =============================================

CREATE POLICY "user_rewards_select_own" ON user_rewards
    FOR SELECT
    USING (user_id = auth.uid() OR public.is_admin());

CREATE POLICY "user_rewards_insert_own" ON user_rewards
    FOR INSERT
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "user_rewards_delete_own" ON user_rewards
    FOR DELETE
    USING (user_id = auth.uid());

-- =============================================
-- Badge Categories Policies
-- =============================================

CREATE POLICY "badge_categories_select_company" ON badge_categories
    FOR SELECT
    USING (account = public.get_user_account() OR public.get_user_role() = 'superAdmin');

CREATE POLICY "badge_categories_insert_admin" ON badge_categories
    FOR INSERT
    WITH CHECK (public.is_admin());

CREATE POLICY "badge_categories_update_admin" ON badge_categories
    FOR UPDATE
    USING (public.is_admin() AND account = public.get_user_account());

CREATE POLICY "badge_categories_delete_admin" ON badge_categories
    FOR DELETE
    USING (public.is_admin() AND account = public.get_user_account());

-- =============================================
-- Badges Policies
-- =============================================

CREATE POLICY "badges_select_company" ON badges
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM badge_categories
            WHERE badge_categories.id = badges.category_id
            AND (badge_categories.account = public.get_user_account() OR public.get_user_role() = 'superAdmin')
        )
    );

CREATE POLICY "badges_insert_admin" ON badges
    FOR INSERT
    WITH CHECK (public.is_admin());

CREATE POLICY "badges_update_admin" ON badges
    FOR UPDATE
    USING (public.is_admin());

CREATE POLICY "badges_delete_admin" ON badges
    FOR DELETE
    USING (public.is_admin());

-- =============================================
-- Badge Reports Policies
-- =============================================

CREATE POLICY "badge_reports_select_admin" ON badge_reports
    FOR SELECT
    USING (public.is_admin());

CREATE POLICY "badge_reports_insert" ON badge_reports
    FOR INSERT
    WITH CHECK (sender_id = auth.uid() OR public.is_admin());  -- Normal flow via SECURITY DEFINER

-- =============================================
-- Acknowledgments Policies
-- =============================================

CREATE POLICY "acknowledgments_select_account" ON acknowledgments
    FOR SELECT
    USING (account = public.get_user_account() OR public.get_user_role() = 'superAdmin');

CREATE POLICY "acknowledgments_insert_auth" ON acknowledgments
    FOR INSERT
    WITH CHECK (sender_id = auth.uid());

CREATE POLICY "acknowledgments_update_admin" ON acknowledgments
    FOR UPDATE
    USING (public.is_admin());

-- =============================================
-- Acknowledgment Recipients Policies
-- =============================================

CREATE POLICY "acknowledgment_recipients_select" ON acknowledgment_recipients
    FOR SELECT
    USING (
        user_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM acknowledgments
            WHERE acknowledgments.id = acknowledgment_recipients.acknowledgment_id
            AND (acknowledgments.account = public.get_user_account() OR acknowledgments.sender_id = auth.uid())
        )
    );

CREATE POLICY "acknowledgment_recipients_insert" ON acknowledgment_recipients
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM acknowledgments
            WHERE acknowledgments.id = acknowledgment_recipients.acknowledgment_id
            AND acknowledgments.sender_id = auth.uid()
        ) OR public.is_admin()
    );  -- Normal flow via SECURITY DEFINER

-- =============================================
-- Rewards Policies
-- =============================================

CREATE POLICY "rewards_select_company" ON rewards
    FOR SELECT
    USING (
        visible = TRUE AND enable = TRUE AND
        (company_name = public.get_user_company() OR public.get_user_role() = 'superAdmin')
    );

CREATE POLICY "rewards_select_admin" ON rewards
    FOR SELECT
    USING (public.is_admin() AND company_name = public.get_user_company());

CREATE POLICY "rewards_insert_admin" ON rewards
    FOR INSERT
    WITH CHECK (public.is_admin());

CREATE POLICY "rewards_update_admin" ON rewards
    FOR UPDATE
    USING (public.is_admin() AND company_name = public.get_user_company());

CREATE POLICY "rewards_delete_admin" ON rewards
    FOR DELETE
    USING (public.is_admin() AND company_name = public.get_user_company());

-- =============================================
-- Reward Likes Policies
-- =============================================

CREATE POLICY "reward_likes_select" ON reward_likes
    FOR SELECT
    USING (TRUE);

CREATE POLICY "reward_likes_insert_auth" ON reward_likes
    FOR INSERT
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "reward_likes_delete_own" ON reward_likes
    FOR DELETE
    USING (user_id = auth.uid());

-- =============================================
-- Carts Policies
-- =============================================

CREATE POLICY "carts_select_own" ON carts
    FOR SELECT
    USING (user_id = auth.uid());

CREATE POLICY "carts_insert_own" ON carts
    FOR INSERT
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "carts_update_own" ON carts
    FOR UPDATE
    USING (user_id = auth.uid());

CREATE POLICY "carts_delete_own" ON carts
    FOR DELETE
    USING (user_id = auth.uid());

-- =============================================
-- Cart Items Policies
-- =============================================

CREATE POLICY "cart_items_select_own" ON cart_items
    FOR SELECT
    USING (
        EXISTS (SELECT 1 FROM carts WHERE carts.id = cart_items.cart_id AND carts.user_id = auth.uid())
    );

CREATE POLICY "cart_items_insert_own" ON cart_items
    FOR INSERT
    WITH CHECK (
        EXISTS (SELECT 1 FROM carts WHERE carts.id = cart_items.cart_id AND carts.user_id = auth.uid())
    );

CREATE POLICY "cart_items_update_own" ON cart_items
    FOR UPDATE
    USING (
        EXISTS (SELECT 1 FROM carts WHERE carts.id = cart_items.cart_id AND carts.user_id = auth.uid())
    );

CREATE POLICY "cart_items_delete_own" ON cart_items
    FOR DELETE
    USING (
        EXISTS (SELECT 1 FROM carts WHERE carts.id = cart_items.cart_id AND carts.user_id = auth.uid())
    );

-- =============================================
-- Exchanges Policies
-- =============================================

CREATE POLICY "exchanges_select_own" ON exchanges
    FOR SELECT
    USING (user_id = auth.uid() OR (public.is_admin() AND company_name = public.get_user_company()));

CREATE POLICY "exchanges_insert" ON exchanges
    FOR INSERT
    WITH CHECK (user_id = auth.uid());  -- Normal flow via SECURITY DEFINER

CREATE POLICY "exchanges_update_admin" ON exchanges
    FOR UPDATE
    USING (public.is_admin() AND company_name = public.get_user_company());

-- =============================================
-- Account Feeds Policies
-- =============================================

CREATE POLICY "account_feeds_select_account" ON account_feeds
    FOR SELECT
    USING (visible = TRUE AND (account = public.get_user_account() OR public.get_user_role() = 'superAdmin'));

CREATE POLICY "account_feeds_insert" ON account_feeds
    FOR INSERT
    WITH CHECK (sender_id = auth.uid() OR public.is_admin());  -- Normal flow via SECURITY DEFINER

CREATE POLICY "account_feeds_update_admin" ON account_feeds
    FOR UPDATE
    USING (public.is_admin());

-- =============================================
-- Feed Comments Policies
-- =============================================

CREATE POLICY "feed_comments_select" ON feed_comments
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM account_feeds
            WHERE account_feeds.id = feed_comments.feed_id
            AND account_feeds.visible = TRUE
        )
    );

CREATE POLICY "feed_comments_insert_auth" ON feed_comments
    FOR INSERT
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "feed_comments_delete_own" ON feed_comments
    FOR DELETE
    USING (user_id = auth.uid() OR public.is_admin());

-- =============================================
-- Feed Likes Policies
-- =============================================

CREATE POLICY "feed_likes_select" ON feed_likes
    FOR SELECT
    USING (TRUE);

CREATE POLICY "feed_likes_insert_auth" ON feed_likes
    FOR INSERT
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "feed_likes_delete_own" ON feed_likes
    FOR DELETE
    USING (user_id = auth.uid());

-- =============================================
-- Activities Policies
-- =============================================

CREATE POLICY "activities_select_own" ON activities
    FOR SELECT
    USING (user_id = auth.uid() OR public.is_admin());

CREATE POLICY "activities_insert" ON activities
    FOR INSERT
    WITH CHECK (user_id = auth.uid() OR public.is_admin());  -- Normal flow via SECURITY DEFINER

CREATE POLICY "activities_update_own" ON activities
    FOR UPDATE
    USING (user_id = auth.uid());

-- =============================================
-- Account Statements Policies
-- =============================================

CREATE POLICY "account_statements_select_own" ON account_statements
    FOR SELECT
    USING (user_id = auth.uid() OR public.is_admin());

CREATE POLICY "account_statements_insert_admin" ON account_statements
    FOR INSERT
    WITH CHECK (public.is_admin());

-- =============================================
-- Statement Transactions Policies
-- =============================================

CREATE POLICY "statement_transactions_select" ON statement_transactions
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM account_statements
            WHERE account_statements.id = statement_transactions.statement_id
            AND (account_statements.user_id = auth.uid() OR public.is_admin())
        )
    );

CREATE POLICY "statement_transactions_insert_admin" ON statement_transactions
    FOR INSERT
    WITH CHECK (public.is_admin());

-- =============================================
-- Ambassadors Policies
-- =============================================

CREATE POLICY "ambassadors_select_company" ON ambassadors
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE users.id = ambassadors.user_id
            AND users.company_name = public.get_user_company()
        ) OR public.get_user_role() = 'superAdmin'
    );

CREATE POLICY "ambassadors_insert_admin" ON ambassadors
    FOR INSERT
    WITH CHECK (public.is_admin());

CREATE POLICY "ambassadors_update_admin" ON ambassadors
    FOR UPDATE
    USING (public.is_admin());

CREATE POLICY "ambassadors_delete_admin" ON ambassadors
    FOR DELETE
    USING (public.is_admin());

-- =============================================
-- Banners Policies
-- =============================================

CREATE POLICY "banners_select_company" ON banners
    FOR SELECT
    USING (
        visible = TRUE AND is_active = TRUE AND
        (company_name = public.get_user_company() OR public.get_user_role() = 'superAdmin')
    );

CREATE POLICY "banners_select_admin" ON banners
    FOR SELECT
    USING (public.is_admin() AND company_name = public.get_user_company());

CREATE POLICY "banners_insert_admin" ON banners
    FOR INSERT
    WITH CHECK (public.is_admin());

CREATE POLICY "banners_update_admin" ON banners
    FOR UPDATE
    USING (public.is_admin() AND company_name = public.get_user_company());

CREATE POLICY "banners_delete_admin" ON banners
    FOR DELETE
    USING (public.is_admin() AND company_name = public.get_user_company());

-- =============================================
-- News Policies
-- =============================================

CREATE POLICY "news_select_public" ON news
    FOR SELECT
    USING (visible = TRUE AND hidden = FALSE);

CREATE POLICY "news_select_admin" ON news
    FOR SELECT
    USING (public.is_admin());

CREATE POLICY "news_insert_admin" ON news
    FOR INSERT
    WITH CHECK (public.is_admin());

CREATE POLICY "news_update_admin" ON news
    FOR UPDATE
    USING (public.is_admin());

CREATE POLICY "news_delete_admin" ON news
    FOR DELETE
    USING (public.is_admin());
