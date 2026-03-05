-- =============================================
-- Bondly Backend Migration: Create Storage Buckets
-- =============================================

-- Create public storage buckets for file uploads
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES
  ('avatars', 'avatars', true, 5242880, ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']),
  ('badges', 'badges', true, 2097152, ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/svg+xml']),
  ('rewards', 'rewards', true, 5242880, ARRAY['image/jpeg', 'image/png', 'image/webp']),
  ('banners', 'banners', true, 10485760, ARRAY['image/jpeg', 'image/png', 'image/webp']),
  ('badge-categories', 'badge-categories', true, 2097152, ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/svg+xml']),
  ('news', 'news', true, 5242880, ARRAY['image/jpeg', 'image/png', 'image/webp'])
ON CONFLICT (id) DO NOTHING;

-- =============================================
-- Storage RLS Policies
-- =============================================

-- Allow public read access to all buckets (they are public)
CREATE POLICY "Public read access" ON storage.objects
  FOR SELECT USING (bucket_id IN ('avatars', 'badges', 'rewards', 'banners', 'badge-categories', 'news'));

-- Avatars: Users can upload to their own folder
CREATE POLICY "Users can upload avatars" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can update own avatars" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can delete own avatars" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- Admin-only buckets: badges, rewards, banners, badge-categories, news
CREATE POLICY "Admins can upload to badges" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'badges'
    AND public.is_admin()
  );

CREATE POLICY "Admins can update badges" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'badges'
    AND public.is_admin()
  );

CREATE POLICY "Admins can delete badges" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'badges'
    AND public.is_admin()
  );

CREATE POLICY "Admins can upload to rewards" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'rewards'
    AND public.is_admin()
  );

CREATE POLICY "Admins can update rewards" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'rewards'
    AND public.is_admin()
  );

CREATE POLICY "Admins can delete rewards" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'rewards'
    AND public.is_admin()
  );

CREATE POLICY "Admins can upload to banners" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'banners'
    AND public.is_admin()
  );

CREATE POLICY "Admins can update banners" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'banners'
    AND public.is_admin()
  );

CREATE POLICY "Admins can delete banners" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'banners'
    AND public.is_admin()
  );

CREATE POLICY "Admins can upload to badge-categories" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'badge-categories'
    AND public.is_admin()
  );

CREATE POLICY "Admins can update badge-categories" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'badge-categories'
    AND public.is_admin()
  );

CREATE POLICY "Admins can delete badge-categories" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'badge-categories'
    AND public.is_admin()
  );

CREATE POLICY "Admins can upload to news" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'news'
    AND public.is_admin()
  );

CREATE POLICY "Admins can update news" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'news'
    AND public.is_admin()
  );

CREATE POLICY "Admins can delete news" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'news'
    AND public.is_admin()
  );
