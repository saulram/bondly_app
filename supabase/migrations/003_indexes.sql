-- =============================================
-- Bondly Backend Migration: Indexes
-- =============================================

-- =============================================
-- Users and Profiles
-- =============================================

-- User lookups by email (already unique, but for performance)
CREATE INDEX idx_users_email ON users(email);

-- User lookups by company
CREATE INDEX idx_users_company_name ON users(company_name);

-- User lookups by account number
CREATE INDEX idx_users_account_number ON users(account_number);

-- Active users filter
CREATE INDEX idx_users_is_active ON users(is_active) WHERE is_active = TRUE;

-- Visible users filter
CREATE INDEX idx_users_visible ON users(visible) WHERE visible = TRUE;

-- User profiles by user
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);

-- User points by user
CREATE INDEX idx_user_points_user_id ON user_points(user_id);

-- User balances by user
CREATE INDEX idx_user_balances_user_id ON user_balances(user_id);

-- User logs by user
CREATE INDEX idx_user_logs_user_id ON user_logs(user_id);

-- User logs by month
CREATE INDEX idx_user_logs_month ON user_logs(log_month);

-- User notifications by user
CREATE INDEX idx_user_notifications_user_id ON user_notifications(user_id);

-- Unread notifications
CREATE INDEX idx_user_notifications_unread ON user_notifications(user_id, read) WHERE read = FALSE;

-- =============================================
-- Badge System
-- =============================================

-- Badge categories by account
CREATE INDEX idx_badge_categories_account ON badge_categories(account);

-- Visible badge categories
CREATE INDEX idx_badge_categories_visible ON badge_categories(visible) WHERE visible = TRUE;

-- Badges by category
CREATE INDEX idx_badges_category_id ON badges(category_id);

-- Active badges
CREATE INDEX idx_badges_is_active ON badges(is_active) WHERE is_active = TRUE;

-- Visible badges
CREATE INDEX idx_badges_visible ON badges(visible) WHERE visible = TRUE;

-- Badge reports by badge
CREATE INDEX idx_badge_reports_badge_id ON badge_reports(badge_id);

-- Badge reports by sender
CREATE INDEX idx_badge_reports_sender_id ON badge_reports(sender_id);

-- Badge reports by receiver
CREATE INDEX idx_badge_reports_receiver_id ON badge_reports(receiver_id);

-- Badge reports by date
CREATE INDEX idx_badge_reports_created_at ON badge_reports(created_at);

-- =============================================
-- Acknowledgments
-- =============================================

-- Acknowledgments by badge
CREATE INDEX idx_acknowledgments_badge_id ON acknowledgments(badge_id);

-- Acknowledgments by sender
CREATE INDEX idx_acknowledgments_sender_id ON acknowledgments(sender_id);

-- Acknowledgments by account
CREATE INDEX idx_acknowledgments_account ON acknowledgments(account);

-- Visible acknowledgments
CREATE INDEX idx_acknowledgments_visible ON acknowledgments(visible) WHERE visible = TRUE;

-- Acknowledgments by creation date
CREATE INDEX idx_acknowledgments_created_at ON acknowledgments(created_at);

-- Acknowledgment recipients by acknowledgment
CREATE INDEX idx_acknowledgment_recipients_acknowledgment_id ON acknowledgment_recipients(acknowledgment_id);

-- Acknowledgment recipients by user
CREATE INDEX idx_acknowledgment_recipients_user_id ON acknowledgment_recipients(user_id);

-- =============================================
-- Rewards
-- =============================================

-- Rewards by account
CREATE INDEX idx_rewards_account ON rewards(account);

-- Rewards by company
CREATE INDEX idx_rewards_company_name ON rewards(company_name);

-- Rewards by category
CREATE INDEX idx_rewards_category ON rewards(category);

-- Enabled rewards
CREATE INDEX idx_rewards_enable ON rewards(enable) WHERE enable = TRUE;

-- Visible rewards
CREATE INDEX idx_rewards_visible ON rewards(visible) WHERE visible = TRUE;

-- Reward likes by reward
CREATE INDEX idx_reward_likes_reward_id ON reward_likes(reward_id);

-- Reward likes by user
CREATE INDEX idx_reward_likes_user_id ON reward_likes(user_id);

-- User rewards by user
CREATE INDEX idx_user_rewards_user_id ON user_rewards(user_id);

-- =============================================
-- Carts
-- =============================================

-- Carts by user
CREATE INDEX idx_carts_user_id ON carts(user_id);

-- Carts by type
CREATE INDEX idx_carts_type ON carts(type);

-- Cart items by cart
CREATE INDEX idx_cart_items_cart_id ON cart_items(cart_id);

-- Cart items by reward
CREATE INDEX idx_cart_items_reward_id ON cart_items(reward_id);

-- =============================================
-- Exchanges
-- =============================================

-- Exchanges by user
CREATE INDEX idx_exchanges_user_id ON exchanges(user_id);

-- Exchanges by reward
CREATE INDEX idx_exchanges_reward_id ON exchanges(reward_id);

-- Exchanges by status
CREATE INDEX idx_exchanges_status ON exchanges(status);

-- Exchanges by company
CREATE INDEX idx_exchanges_company_name ON exchanges(company_name);

-- Exchanges by date
CREATE INDEX idx_exchanges_created_at ON exchanges(created_at);

-- =============================================
-- Account Feeds
-- =============================================

-- Feeds by account
CREATE INDEX idx_account_feeds_account ON account_feeds(account);

-- Feeds by sender
CREATE INDEX idx_account_feeds_sender_id ON account_feeds(sender_id);

-- Feeds by type
CREATE INDEX idx_account_feeds_type ON account_feeds(type);

-- Visible feeds
CREATE INDEX idx_account_feeds_visible ON account_feeds(visible) WHERE visible = TRUE;

-- Feeds by date (for timeline)
CREATE INDEX idx_account_feeds_created_at ON account_feeds(created_at DESC);

-- Feed comments by feed
CREATE INDEX idx_feed_comments_feed_id ON feed_comments(feed_id);

-- Feed comments by user
CREATE INDEX idx_feed_comments_user_id ON feed_comments(user_id);

-- Feed likes by feed
CREATE INDEX idx_feed_likes_feed_id ON feed_likes(feed_id);

-- =============================================
-- Activities
-- =============================================

-- Activities by user
CREATE INDEX idx_activities_user_id ON activities(user_id);

-- Unread activities
CREATE INDEX idx_activities_unread ON activities(user_id, read) WHERE read = FALSE;

-- Activities by company
CREATE INDEX idx_activities_company_name ON activities(company_name);

-- Activities by date
CREATE INDEX idx_activities_created_at ON activities(created_at DESC);

-- =============================================
-- Account Statements
-- =============================================

-- Statements by user
CREATE INDEX idx_account_statements_user_id ON account_statements(user_id);

-- Statements by date
CREATE INDEX idx_account_statements_date ON account_statements(date);

-- Statement transactions by statement
CREATE INDEX idx_statement_transactions_statement_id ON statement_transactions(statement_id);

-- Statement transactions by type
CREATE INDEX idx_statement_transactions_type ON statement_transactions(type);

-- =============================================
-- Ambassadors
-- =============================================

-- Ambassadors by user
CREATE INDEX idx_ambassadors_user_id ON ambassadors(user_id);

-- Ambassadors by badge
CREATE INDEX idx_ambassadors_badge_id ON ambassadors(badge_id);

-- Visible ambassadors
CREATE INDEX idx_ambassadors_visible ON ambassadors(visible) WHERE visible = TRUE;

-- =============================================
-- Content
-- =============================================

-- Banners by company
CREATE INDEX idx_banners_company_name ON banners(company_name);

-- Active banners
CREATE INDEX idx_banners_is_active ON banners(is_active) WHERE is_active = TRUE;

-- Visible banners
CREATE INDEX idx_banners_visible ON banners(visible) WHERE visible = TRUE;

-- Visible news
CREATE INDEX idx_news_visible ON news(visible) WHERE visible = TRUE;

-- News by date
CREATE INDEX idx_news_created_at ON news(created_at DESC);
