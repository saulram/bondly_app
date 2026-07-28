-- =============================================
-- Bondly Backend Migration: Storage Buckets
-- =============================================

-- Note: Storage bucket creation is done via Supabase Dashboard or CLI
-- This file documents the expected configuration

-- =============================================
-- Bucket Definitions (to be created in Supabase)
-- =============================================

-- 1. avatars - User profile pictures
--    Public: Yes
--    Allowed MIME types: image/jpeg, image/png, image/webp, image/gif
--    Max file size: 5MB

-- 2. badges - Badge images
--    Public: Yes
--    Allowed MIME types: image/jpeg, image/png, image/webp, image/svg+xml
--    Max file size: 2MB

-- 3. rewards - Reward catalog images
--    Public: Yes
--    Allowed MIME types: image/jpeg, image/png, image/webp
--    Max file size: 5MB

-- 4. banners - Marketing banner images
--    Public: Yes
--    Allowed MIME types: image/jpeg, image/png, image/webp
--    Max file size: 10MB

-- 5. badge-categories - Category icons
--    Public: Yes
--    Allowed MIME types: image/jpeg, image/png, image/webp, image/svg+xml
--    Max file size: 2MB

-- 6. news - News article images
--    Public: Yes
--    Allowed MIME types: image/jpeg, image/png, image/webp
--    Max file size: 5MB

-- =============================================
-- Storage Policies (RLS for Storage)
-- =============================================

-- AVATARS BUCKET POLICIES
-- Users can upload/update their own avatar

-- SELECT: Anyone can view avatars (public bucket)
-- INSERT: Authenticated users can upload to their own folder
-- UPDATE: Users can update their own avatar
-- DELETE: Users can delete their own avatar

-- Policy naming convention: {bucket}_{operation}_{scope}
-- Example: avatars_insert_own

-- Note: Actual policy creation is done via Supabase Dashboard
-- Below are the SQL equivalents for documentation

/*
-- Avatars: Users upload to their own folder (user_id/filename)
CREATE POLICY "avatars_insert_own" ON storage.objects
FOR INSERT WITH CHECK (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "avatars_update_own" ON storage.objects
FOR UPDATE USING (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "avatars_delete_own" ON storage.objects
FOR DELETE USING (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

-- Badges: Only admins can manage
CREATE POLICY "badges_insert_admin" ON storage.objects
FOR INSERT WITH CHECK (
    bucket_id = 'badges' AND
    auth.is_admin()
);

CREATE POLICY "badges_update_admin" ON storage.objects
FOR UPDATE USING (
    bucket_id = 'badges' AND
    auth.is_admin()
);

CREATE POLICY "badges_delete_admin" ON storage.objects
FOR DELETE USING (
    bucket_id = 'badges' AND
    auth.is_admin()
);

-- Rewards: Only admins can manage
CREATE POLICY "rewards_insert_admin" ON storage.objects
FOR INSERT WITH CHECK (
    bucket_id = 'rewards' AND
    auth.is_admin()
);

CREATE POLICY "rewards_update_admin" ON storage.objects
FOR UPDATE USING (
    bucket_id = 'rewards' AND
    auth.is_admin()
);

CREATE POLICY "rewards_delete_admin" ON storage.objects
FOR DELETE USING (
    bucket_id = 'rewards' AND
    auth.is_admin()
);

-- Banners: Only admins can manage
CREATE POLICY "banners_insert_admin" ON storage.objects
FOR INSERT WITH CHECK (
    bucket_id = 'banners' AND
    auth.is_admin()
);

CREATE POLICY "banners_update_admin" ON storage.objects
FOR UPDATE USING (
    bucket_id = 'banners' AND
    auth.is_admin()
);

CREATE POLICY "banners_delete_admin" ON storage.objects
FOR DELETE USING (
    bucket_id = 'banners' AND
    auth.is_admin()
);

-- Badge Categories: Only admins can manage
CREATE POLICY "badge_categories_insert_admin" ON storage.objects
FOR INSERT WITH CHECK (
    bucket_id = 'badge-categories' AND
    auth.is_admin()
);

CREATE POLICY "badge_categories_update_admin" ON storage.objects
FOR UPDATE USING (
    bucket_id = 'badge-categories' AND
    auth.is_admin()
);

CREATE POLICY "badge_categories_delete_admin" ON storage.objects
FOR DELETE USING (
    bucket_id = 'badge-categories' AND
    auth.is_admin()
);

-- News: Only admins can manage
CREATE POLICY "news_insert_admin" ON storage.objects
FOR INSERT WITH CHECK (
    bucket_id = 'news' AND
    auth.is_admin()
);

CREATE POLICY "news_update_admin" ON storage.objects
FOR UPDATE USING (
    bucket_id = 'news' AND
    auth.is_admin()
);

CREATE POLICY "news_delete_admin" ON storage.objects
FOR DELETE USING (
    bucket_id = 'news' AND
    auth.is_admin()
);
*/

-- =============================================
-- Helper Function for Storage URL
-- =============================================

CREATE OR REPLACE FUNCTION get_storage_url(bucket TEXT, path TEXT)
RETURNS TEXT AS $$
BEGIN
    -- Returns the public URL for a storage object
    -- Replace SUPABASE_URL with actual project URL
    RETURN 'https://your-project.supabase.co/storage/v1/object/public/' || bucket || '/' || path;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- =============================================
-- Storage Migration Notes
-- =============================================

-- Current file structure in Express backend:
-- public/upload/avatars/
-- public/upload/badges/
-- public/upload/rewards/
-- public/upload/banners/
-- public/upload/badgeCategory/
-- public/upload/news/

-- Migration steps:
-- 1. Create buckets in Supabase Dashboard
-- 2. Run migration script to upload files
-- 3. Update database records with new URLs
-- 4. Verify all images are accessible
