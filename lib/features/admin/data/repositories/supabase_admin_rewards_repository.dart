import 'dart:typed_data';

import 'package:bondly_app/features/admin/domain/models/admin_reward.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAdminRewardsRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminRewardsRepository(this._supabase);

  /// Uploads image [bytes] to the public `rewards` bucket and returns its URL.
  /// [ext] is the file extension (jpg/jpeg/png/webp); admins-only via storage RLS.
  Future<Result<String, Exception>> uploadImage(
      Uint8List bytes, String ext) async {
    try {
      final safeExt = ext == 'jpeg' ? 'jpg' : ext;
      final contentType = 'image/${ext == 'jpg' ? 'jpeg' : ext}';
      final fileName =
          'reward_${DateTime.now().millisecondsSinceEpoch}.$safeExt';
      await _supabase.client.storage.from('rewards').uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(contentType: contentType, upsert: true),
          );
      final url =
          _supabase.client.storage.from('rewards').getPublicUrl(fileName);
      return Result.success(url);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<List<AdminReward>, Exception>> getRewards() async {
    try {
      final response = await _supabase.client
          .from('rewards')
          .select()
          .order('created_at', ascending: false);
      final items = (response as List)
          .map((e) => AdminReward.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> toggleEnable(
      String rewardId, bool enable) async {
    try {
      await _supabase.client
          .from('rewards')
          .update({'enable': enable}).eq('id', rewardId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> createReward({
    required String name,
    String? description,
    String? category,
    required int points,
    String? image,
    DateTime? deadline,
  }) async {
    try {
      await _supabase.client.from('rewards').insert({
        'name': name,
        'description': description,
        'category': category,
        'points': points,
        'image': image,
        'deadline': deadline?.toIso8601String(),
        'enable': true,
        'visible': true,
      });
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> updateReward({
    required String rewardId,
    required String name,
    String? description,
    String? category,
    required int points,
    String? image,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'description': description,
        'category': category,
        'points': points,
      };
      // Only overwrite the image when a new one was chosen.
      if (image != null) data['image'] = image;
      await _supabase.client.from('rewards').update(data).eq('id', rewardId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> deleteReward(String rewardId) async {
    try {
      await _supabase.client.from('rewards').delete().eq('id', rewardId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
