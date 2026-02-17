import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/home/domain/models/announcement_model.dart';
import 'package:bondly_app/features/home/domain/models/badge_model.dart';
import 'package:bondly_app/features/home/domain/models/category_badges.dart';
import 'package:bondly_app/features/home/domain/models/company_categories.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/domain/models/embassys_model.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseCompanyFeedsRepository extends CompanyFeedsRepository {
  final SupabaseClientProvider _provider;

  SupabaseCompanyFeedsRepository(this._provider);

  String? get _currentUserId => _provider.client.auth.currentUser?.id;

  @override
  Future<Result<CompanyFeed, Exception>> getCompanyFeeds() async {
    try {
      final response = await _provider.client
          .from('account_feeds')
          .select(
              '*, sender:users!sender_id(*), feed_comments(*, user:users!user_id(*)), feed_likes(*)')
          .eq('visible', true)
          .order('created_at', ascending: false);

      final feeds = (response as List)
          .map((row) => FeedData.fromSupabase(row as Map<String, dynamic>))
          .toList();

      return Result.success(CompanyFeed(success: true, data: feeds));
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<FeedData, Exception>> getCompanyFeedById(
    String feedId,
  ) async {
    try {
      final response = await _provider.client
          .from('account_feeds')
          .select(
              '*, sender:users!sender_id(*), feed_comments(*, user:users!user_id(*)), feed_likes(*)')
          .eq('id', feedId)
          .single();

      return Result.success(FeedData.fromSupabase(response));
    } catch (exception) {
      return Result.error(FeedNotFoundException());
    }
  }

  @override
  Future<Result<FeedData, Exception>> createComment(
    String feedId,
    String message,
  ) async {
    try {
      await _provider.client.from('feed_comments').insert({
        'feed_id': feedId,
        'user_id': _currentUserId,
        'message': message,
      });

      final response = await _provider.client
          .from('account_feeds')
          .select(
              '*, sender:users!sender_id(*), feed_comments(*, user:users!user_id(*)), feed_likes(*)')
          .eq('id', feedId)
          .single();

      return Result.success(FeedData.fromSupabase(response));
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<bool, Exception>> likePost(String feedId) async {
    try {
      final existing = await _provider.client
          .from('feed_likes')
          .select()
          .eq('feed_id', feedId)
          .eq('user_id', _currentUserId!);

      if ((existing as List).isNotEmpty) {
        await _provider.client
            .from('feed_likes')
            .delete()
            .eq('feed_id', feedId)
            .eq('user_id', _currentUserId!);
      } else {
        await _provider.client.from('feed_likes').insert({
          'feed_id': feedId,
          'user_id': _currentUserId,
        });
      }

      return Result.success(true);
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<Categories, Exception>> getCategories() async {
    try {
      final response = await _provider.client
          .from('badge_categories')
          .select()
          .eq('visible', true);

      final categories = (response as List)
          .map((row) => Category.fromSupabase(row as Map<String, dynamic>))
          .toList();

      return Result.success(Categories(categories: categories));
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<Badges, Exception>> getBadges(String categoryId) async {
    try {
      final response = await _provider.client
          .from('badges')
          .select()
          .eq('category_id', categoryId)
          .eq('is_active', true);

      final badges = (response as List)
          .map((row) => Badge.fromSupabase(row as Map<String, dynamic>))
          .toList();

      return Result.success(Badges(badges: badges));
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<List<User>, Exception>> getCompanyCollaborators() async {
    try {
      final currentUserData = await _provider.client
          .from('users')
          .select('company_name')
          .eq('id', _currentUserId!)
          .single();

      final companyName = currentUserData['company_name'] as String;

      final response = await _provider.client
          .from('users')
          .select()
          .eq('company_name', companyName)
          .eq('visible', true);

      final collaborators = (response as List)
          .map((row) => User.fromSupabase(row as Map<String, dynamic>))
          .toList();

      return Result.success(collaborators);
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<bool, Exception>> createAcknowledgment(
    String badgeId,
    String message,
    List<String> recipients,
  ) async {
    try {
      final ackResponse = await _provider.client
          .from('acknowledgments')
          .insert({
            'sender_id': _currentUserId,
            'badge_id': badgeId,
            'message': message,
          })
          .select()
          .single();

      final ackId = ackResponse['id'];

      final recipientRows = recipients
          .map((recipientId) => {
                'acknowledgment_id': ackId,
                'recipient_id': recipientId,
              })
          .toList();

      await _provider.client
          .from('acknowledgment_recipients')
          .insert(recipientRows);

      return Result.success(true);
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<Announcements, Exception>> getCompanyAnnouncements() async {
    try {
      final response = await _provider.client
          .from('news')
          .select()
          .eq('visible', true)
          .eq('hidden', false)
          .order('created_at', ascending: false);

      final announcements = (response as List)
          .map((row) =>
              Announcement.fromSupabase(row as Map<String, dynamic>))
          .toList();

      return Result.success(Announcements(announcement: announcements));
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<List<Embassy>, Exception>> getUserEmbassys(
    String userId,
  ) async {
    try {
      final response = await _provider.client
          .from('ambassadors')
          .select('*, badge:badges(*)')
          .eq('user_id', userId)
          .eq('visible', true);

      final embassys = (response as List)
          .map((row) => Embassy.fromSupabase(row as Map<String, dynamic>))
          .toList();

      return Result.success(embassys);
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }
}
