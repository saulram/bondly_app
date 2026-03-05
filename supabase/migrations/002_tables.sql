-- =============================================
-- Bondly Backend Migration: Tables
-- =============================================

-- Note: gen_random_uuid() is built into PostgreSQL 13+, no extension needed

-- =============================================
-- Core User Tables
-- =============================================

-- Main users table (synced with auth.users)
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    complete_name TEXT,
    employee_number INTEGER,
    avatar TEXT,
    role user_role DEFAULT 'client',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    account_number INTEGER,
    account_holder INTEGER,
    email TEXT UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    seats INTEGER DEFAULT 0,
    plan_type plan_type DEFAULT 'free',
    monthly_points INTEGER DEFAULT 0,
    account_type account_type DEFAULT 'invitee',
    company_name TEXT,
    points_received INTEGER DEFAULT 0,
    gifted_points INTEGER DEFAULT 0,
    visible BOOLEAN DEFAULT TRUE,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- User profile with additional details
CREATE TABLE user_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    job_position TEXT,
    location TEXT,
    job_area TEXT,
    is_ambassador BOOLEAN DEFAULT FALSE,
    ambassador_title TEXT,
    b_day DATE,
    company_name TEXT,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id)
);

-- User points tracking
CREATE TABLE user_points (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    earned INTEGER DEFAULT 0,
    to_give INTEGER DEFAULT 0,
    last_refill TIMESTAMPTZ,
    refill_amount INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id)
);

-- User balance per period
CREATE TABLE user_balances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    period TEXT,
    initial_balance INTEGER DEFAULT 0,
    final_balance INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- User activity logs
CREATE TABLE user_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    create_at TIMESTAMPTZ DEFAULT NOW(),
    log_description TEXT,
    log_month TEXT
);

-- User notifications
CREATE TABLE user_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    header TEXT,
    body TEXT,
    footer TEXT,
    section TEXT,
    read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Junction table: Users <-> Rewards (favorites/owned)
CREATE TABLE user_rewards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reward_id UUID NOT NULL,  -- Will reference rewards table
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, reward_id)
);

-- =============================================
-- Badge System Tables
-- =============================================

-- Badge categories
CREATE TABLE badge_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    account INTEGER,
    type TEXT,
    description TEXT,
    image_url TEXT,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Badges (achievement types)
CREATE TABLE badges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL REFERENCES badge_categories(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    image TEXT,
    value INTEGER DEFAULT 0,
    expires TIMESTAMPTZ,
    is_active BOOLEAN DEFAULT TRUE,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Badge reports (analytics)
CREATE TABLE badge_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL REFERENCES badge_categories(id) ON DELETE CASCADE,
    badge_id UUID NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
    sender_profile_id UUID REFERENCES user_profiles(id) ON DELETE SET NULL,
    receiver_profile_id UUID REFERENCES user_profiles(id) ON DELETE SET NULL,
    sender_id UUID REFERENCES users(id) ON DELETE SET NULL,
    receiver_id UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Acknowledgment (Recognition) Tables
-- =============================================

-- Acknowledgments (when someone gives a badge)
CREATE TABLE acknowledgments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    badge_id UUID NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL, -- Legacy recipient field
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message TEXT,
    hidden BOOLEAN DEFAULT FALSE,
    account INTEGER,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Acknowledgment recipients (one-to-many from acknowledgments)
CREATE TABLE acknowledgment_recipients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    acknowledgment_id UUID NOT NULL REFERENCES acknowledgments(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(acknowledgment_id, user_id)
);

-- =============================================
-- Reward System Tables
-- =============================================

-- Reward catalog
CREATE TABLE rewards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    category TEXT,
    points INTEGER DEFAULT 0,
    image TEXT,
    deadline TIMESTAMPTZ,
    company_name TEXT,
    account INTEGER,
    enable BOOLEAN DEFAULT TRUE,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add foreign key for user_rewards now that rewards table exists
ALTER TABLE user_rewards
ADD CONSTRAINT user_rewards_reward_id_fkey
FOREIGN KEY (reward_id) REFERENCES rewards(id) ON DELETE CASCADE;

-- Reward likes
CREATE TABLE reward_likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reward_id UUID NOT NULL REFERENCES rewards(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(reward_id, user_id)
);

-- =============================================
-- Cart System Tables
-- =============================================

-- Shopping carts / wishlists
CREATE TABLE carts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    total INTEGER DEFAULT 0,
    type cart_type DEFAULT 'cart',
    company_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, type)
);

-- Cart items
CREATE TABLE cart_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cart_id UUID NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
    reward_id UUID NOT NULL REFERENCES rewards(id) ON DELETE CASCADE,
    quantity INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(cart_id, reward_id)
);

-- =============================================
-- Exchange (Redemption) Tables
-- =============================================

-- Exchanges (reward redemptions)
CREATE TABLE exchanges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reward_id UUID NOT NULL REFERENCES rewards(id) ON DELETE CASCADE,
    code TEXT,
    status exchange_status DEFAULT 'En espera',
    company_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Activity Feed Tables
-- =============================================

-- Account feeds (activity feed entries)
CREATE TABLE account_feeds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account INTEGER,
    header TEXT,
    body TEXT,
    footer TEXT,
    image TEXT,
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    is_highlighted BOOLEAN DEFAULT FALSE,
    type feed_type,
    badge_id UUID REFERENCES badges(id) ON DELETE SET NULL,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Feed comments
CREATE TABLE feed_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    feed_id UUID NOT NULL REFERENCES account_feeds(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Feed likes
CREATE TABLE feed_likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    feed_id UUID NOT NULL REFERENCES account_feeds(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(feed_id, user_id)
);

-- =============================================
-- Activity / Notification Tables
-- =============================================

-- Activities (user activity log)
CREATE TABLE activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title TEXT,
    content TEXT,
    read BOOLEAN DEFAULT FALSE,
    company_name TEXT,
    feed_id UUID REFERENCES account_feeds(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Account Statement Tables
-- =============================================

-- Account statements
CREATE TABLE account_statements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    date TIMESTAMPTZ NOT NULL,
    balance INTEGER NOT NULL DEFAULT 0,
    description TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Statement transactions
CREATE TABLE statement_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    statement_id UUID NOT NULL REFERENCES account_statements(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    amount INTEGER NOT NULL,
    type transaction_type NOT NULL,
    date TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Ambassador Tables
-- =============================================

-- Ambassadors
CREATE TABLE ambassadors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    badge_id UUID REFERENCES badges(id) ON DELETE SET NULL,
    date TIMESTAMPTZ,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Content Management Tables
-- =============================================

-- Banners
CREATE TABLE banners (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT,
    image TEXT,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    company_name TEXT,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- News articles
CREATE TABLE news (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT,
    content TEXT,
    image TEXT,
    hidden BOOLEAN DEFAULT TRUE,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
