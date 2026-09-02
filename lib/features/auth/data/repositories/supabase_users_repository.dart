import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/profile/domain/models/user_profile.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseUsersRepository extends UsersRepository {
  static const String name = "RemoteUsersRepository";
  final SupabaseClientProvider _provider;

  SupabaseUsersRepository(this._provider);

  @override
  Future<Result<User, Exception>> getUser() async {
    try {
      final currentUser = _provider.client.auth.currentUser;
      if (currentUser == null) {
        return Result.error(UserUnavailableException());
      }

      final userData = await _provider.client
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .single();

      final session = _provider.client.auth.currentSession;
      final user = User.fromSupabaseAuth(
        userData,
        session?.accessToken ?? '',
      );
      return Result.success(user);
    } catch (exception) {
      return Result.error(InvalidLoginException());
    }
  }

  @override
  Future<void> insertUser(User user) async {
    try {
      await _provider.client.from('users').upsert(user.toJson());
    } catch (exception) {
      throw UserUpdateException();
    }
  }

  @override
  Future<void> updateAvatar(List<dynamic> params) async {
    try {
      if (params.isEmpty) {
        throw UserUpdateException();
      }

      final userId = _provider.client.auth.currentUser?.id;
      if (userId == null) throw UserUnavailableException();

      final fileBytes = params.first;
      final fileName =
          params.length > 1 ? params.last as String : 'avatar_$userId.jpg';

      await _provider.client.storage
          .from('avatars')
          .uploadBinary(fileName, fileBytes);

      final publicUrl =
          _provider.client.storage.from('avatars').getPublicUrl(fileName);

      await _provider.client
          .from('users')
          .update({'avatar': publicUrl}).eq('id', userId);
    } catch (exception) {
      throw UserUpdateException();
    }
  }

  @override
  Future<Result<UserProfile, Exception>> getFullProfile(
    String userId,
  ) async {
    try {
      final userData = await _provider.client
          .from('users')
          .select('*, user_profiles(*)')
          .eq('id', userId)
          .single();

      final profile = UserProfile.fromSupabase(userData);
      return Result.success(profile);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<void> updateProfile(Map<String, String> data) async {
    try {
      final userId = data['id'] ?? _provider.client.auth.currentUser?.id;
      if (userId == null) throw UserUnavailableException();

      // Translate camelCase keys to snake_case for Supabase columns
      final profileUpdate = <String, String>{};
      if (data['location'] != null) {
        profileUpdate['location'] = data['location']!;
      }
      if (data['jobPosition'] != null) {
        profileUpdate['job_position'] = data['jobPosition']!;
      }
      if (data['bDay'] != null && data['bDay']!.isNotEmpty) {
        profileUpdate['b_day'] = data['bDay']!;
      }

      if (profileUpdate.isNotEmpty) {
        await _provider.client
            .from('user_profiles')
            .update(profileUpdate)
            .eq('user_id', userId);
      }

      // Update email on the users table
      if (data['email'] != null) {
        await _provider.client
            .from('users')
            .update({'email': data['email']!}).eq('id', userId);
      }
    } catch (exception) {
      throw UserUpdateException();
    }
  }

  @override
  Future<void> clear() async {
    await _provider.client.auth.signOut();
  }
}
