# Bondly Supabase Migration

This directory contains all files needed to migrate the Bondly backend from MongoDB/Express to Supabase.

## Directory Structure

```
supabase/
├── config.toml                        # Supabase local development config
├── migrations/
│   ├── 001_enums.sql                  # PostgreSQL ENUM types
│   ├── 002_tables.sql                 # All database tables
│   ├── 003_indexes.sql                # Performance indexes
│   ├── 004_functions.sql              # Database functions (RLS helpers + business logic)
│   ├── 005_rls_policies.sql           # Row Level Security policies
│   ├── 006_triggers.sql               # Database triggers
│   └── 007_storage.sql                # Storage bucket documentation
└── functions/
    ├── generate-badge-report/         # CSV report for badges
    ├── generate-exchange-report/      # CSV report for exchanges
    ├── treemap-chart/                 # Treemap visualization data
    ├── area-chart/                    # Area chart time series
    └── feed-chart/                    # Feed activity chart data
```

## Setup Instructions

### 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Note your project URL and anon key

### 2. Run Migrations

```bash
# Install Supabase CLI
npm install -g supabase

# Link to your project
supabase link --project-ref your-project-ref

# Run all migrations
supabase db push
```

Or manually in SQL Editor:
1. Go to Supabase Dashboard → SQL Editor
2. Run each migration file in order (001 → 007)

### 3. Create Storage Buckets

In Supabase Dashboard → Storage:

1. Create `avatars` bucket (Public)
2. Create `badges` bucket (Public)
3. Create `rewards` bucket (Public)
4. Create `banners` bucket (Public)
5. Create `badge-categories` bucket (Public)
6. Create `news` bucket (Public)

### 4. Deploy Edge Functions

```bash
# Deploy all functions
supabase functions deploy generate-badge-report
supabase functions deploy generate-exchange-report
supabase functions deploy treemap-chart
supabase functions deploy area-chart
supabase functions deploy feed-chart
```

### 5. Run Data Migration

```bash
# Set environment variables
export MONGO_API="mongodb://..."
export SUPABASE_URL="https://your-project.supabase.co"
export SUPABASE_SERVICE_ROLE_KEY="your-service-role-key"

# Install dependencies
npm install @supabase/supabase-js mongoose uuid

# Run migration
npx ts-node scripts/migrate-to-supabase.ts

# Migrate storage files
npx ts-node scripts/migrate-storage.ts
```

## Database Schema

### Core Tables

| Table | Description |
|-------|-------------|
| `users` | User accounts (linked to auth.users) |
| `user_profiles` | Extended user info (job, birthday, etc.) |
| `user_points` | Point tracking and refill info |
| `user_balances` | Period-based balance history |

### Badge System

| Table | Description |
|-------|-------------|
| `badge_categories` | Categories for badges |
| `badges` | Achievement badges |
| `acknowledgments` | Badge giving records |
| `acknowledgment_recipients` | Who received each badge |
| `badge_reports` | Analytics data |

### Reward System

| Table | Description |
|-------|-------------|
| `rewards` | Reward catalog |
| `reward_likes` | Likes on rewards |
| `carts` | Shopping carts (cart + wishlist) |
| `cart_items` | Items in carts |
| `exchanges` | Redeemed rewards |

### Activity Feed

| Table | Description |
|-------|-------------|
| `account_feeds` | Feed entries |
| `feed_comments` | Comments on feeds |
| `feed_likes` | Likes on feeds |
| `activities` | User activity notifications |

## RLS Security Model

| Role | Access |
|------|--------|
| `superAdmin` | Full access to all data |
| `admin` | Full access within company |
| `client` | Access own data + company shared data |

Key RLS patterns:
- Users see only their company's data
- Users can only modify their own records
- Admins can modify company records
- Business logic functions use `SECURITY DEFINER`

## API Functions

### Transactional Operations

| Function | Description |
|----------|-------------|
| `create_acknowledgment()` | Give badges with point deduction |
| `add_to_cart()` | Add items with total recalculation |
| `checkout_cart()` | Process redemption with exchanges |
| `toggle_feed_like()` | Like/unlike feeds |
| `monthly_points_refill()` | Scheduled point refill |

### Query Functions

| Function | Description |
|----------|-------------|
| `get_account_feeds()` | Get feeds with likes/comments |
| `get_user_stats()` | Dashboard statistics |

## Environment Variables

```bash
# Required for migration
MONGO_API=mongodb://...
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJ...

# Client-side (public)
EXPO_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=eyJ...
```

## Post-Migration Checklist

- [ ] All migrations run successfully
- [ ] Storage buckets created
- [ ] Edge functions deployed
- [ ] Data migrated from MongoDB
- [ ] Files migrated to Storage
- [ ] RLS policies verified
- [ ] Client app updated and tested
- [ ] Realtime subscriptions working
- [ ] Performance baseline established
