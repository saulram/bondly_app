import 'dart:math';
import 'dart:typed_data';

import 'package:bondly_app/features/admin/data/validators/banner_image_validator.dart';
import 'package:bondly_app/features/admin/domain/models/admin_banner.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAdminBannersRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminBannersRepository(this._supabase);

  Future<Result<List<AdminBanner>, Exception>> getBanners() async {
    try {
      final response = await _supabase.client
          .from('banners')
          .select()
          .order('created_at', ascending: false);
      final items = (response as List)
          .map((e) => AdminBanner.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> toggleActive(
      String bannerId, bool isActive) async {
    try {
      await _supabase.client
          .from('banners')
          .update({'is_active': isActive}).eq('id', bannerId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<String, Exception>> uploadBannerImage(Uint8List bytes) async {
    try {
      final info = BannerImageValidator.validate(bytes);
      final name =
          'banner_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(1 << 32).toRadixString(16)}.${info.extension}';
      await _supabase.client.storage.from('banners').uploadBinary(
            name,
            bytes,
            fileOptions: FileOptions(
              contentType: info.contentType,
              upsert: false,
            ),
          );
      return Result.success(
          _supabase.client.storage.from('banners').getPublicUrl(name));
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<AdminBanner, Exception>> createBanner({
    required String name,
    String? slug,
    String? description,
    Uint8List? imageBytes,
  }) async {
    String? uploaded;
    try {
      if (imageBytes != null) {
        final upload = await uploadBannerImage(imageBytes);
        if (upload.isError()) return Result.error(upload.tryGetError()!);
        uploaded = upload.tryGetSuccess()!;
      }
      final row = await _supabase.client
          .from('banners')
          .insert({
            'name': name,
            'slug': slug,
            'description': description,
            'image': uploaded,
            'is_active': true,
            'visible': true,
          })
          .select()
          .single();
      return Result.success(AdminBanner.fromJson(row));
    } catch (e) {
      if (uploaded != null) await _removeOwnedObject(uploaded);
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<AdminBanner, Exception>> updateBanner({
    required String bannerId,
    required String name,
    String? slug,
    String? description,
    Uint8List? imageBytes,
  }) async {
    String? uploaded;
    var dbCommitted = false;
    try {
      final previous = await _supabase.client
          .from('banners')
          .select('image')
          .eq('id', bannerId)
          .single();
      if (imageBytes != null) {
        final upload = await uploadBannerImage(imageBytes);
        if (upload.isError()) return Result.error(upload.tryGetError()!);
        uploaded = upload.tryGetSuccess()!;
      }
      final data = <String, dynamic>{
        'name': name,
        'slug': slug,
        'description': description,
      };
      if (uploaded != null) {
        data['image'] = uploaded;
      }
      final row = await _supabase.client
          .from('banners')
          .update(data)
          .eq('id', bannerId)
          .select()
          .single();
      dbCommitted = true;
      final result = AdminBanner.fromJson(row);
      if (uploaded != null) {
        await _removeOwnedObject(previous['image'] as String?);
      }
      return Result.success(result);
    } catch (e) {
      if (!dbCommitted && uploaded != null) {
        await _removeOwnedObject(uploaded);
      }
      return Result.error(Exception(e.toString()));
    }
  }

  static final Random _random = Random.secure();

  Future<void> _removeOwnedObject(String? url) async {
    if (url == null) {
      return;
    }
    try {
      // Derive the canonical origin and bucket prefix from Supabase itself;
      // this works for local, hosted, and custom-domain deployments.
      final originProbe = _supabase.client.storage
          .from('banners')
          .getPublicUrl('banner_origin_probe.jpg');
      final path = BannerStorageUrlDecoder.decodeOwnedBannerPath(
        candidateUrl: url,
        originProbeUrl: originProbe,
      );
      if (path == null) return;
      await _supabase.client.storage.from('banners').remove([path]);
    } catch (_) {
      // Cleanup must never hide the successful database operation.
    }
  }

  Future<Result<void, Exception>> deleteBanner(String bannerId) async {
    try {
      final previous = await _supabase.client
          .from('banners')
          .select('image')
          .eq('id', bannerId)
          .single();
      await _supabase.client.from('banners').delete().eq('id', bannerId);
      // The row is committed; cleanup is deliberately best-effort.
      await _removeOwnedObject(previous['image'] as String?);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
