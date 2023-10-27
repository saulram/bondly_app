import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/home/domain/models/announcement_model.dart';
import 'package:bondly_app/features/home/domain/models/category_badges.dart';
import 'package:bondly_app/features/home/domain/models/company_categories.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/domain/models/embassys_model.dart';
import 'package:multiple_result/multiple_result.dart';

/// This abstract class defines the methods that a company feeds repository should implement.
/// It provides methods to get company feeds, create comments, like posts, get categories and get badges.
abstract class CompanyFeedsRepository {
  /// This method retrieves the company feeds.
  /// Returns a [Result] object that contains either a [CompanyFeed] object or an [Exception].
  Future<Result<CompanyFeed, Exception>> getCompanyFeeds();

  /// This method creates a comment for a specific feed.
  /// Takes in a [feedId] and a [message] as parameters.
  /// Returns a [Result] object that contains either a [FeedData] object or an [Exception].
  Future<Result<FeedData, Exception>> createComment(
      String feedId, String message);

  /// This method likes a specific post.
  /// Takes in a [feedId] as a parameter.
  /// Returns a [Result] object that contains either a [bool] value or an [Exception].
  Future<Result<bool, Exception>> likePost(String feedId);

  /// This method retrieves the categories.
  /// Returns a [Result] object that contains either a [Categories] object or an [Exception].
  Future<Result<Categories, Exception>> getCategories();

  /// This method retrieves the badges.
  /// Returns a [Result] object that contains either a [Badges] object or an [Exception].
  Future<Result<Badges, Exception>> getBadges(String categoryId);

  /// This method retrieves the company collaborators.
  /// Returns a [Result] object that contains either a [List] of [User] objects or an [Exception].
  Future<Result<List<User>, Exception>> getCompanyCollaborators();
  Future<Result<bool, Exception>> createAcknowledgment(
      String badgeId, String message, List<String> recipients);

  ///This method returns the announcements of the company.
  ///Returns a [Result] object that contains either a [Announcements] object or an [Exception].

  Future<Result<Announcements, Exception>> getCompanyAnnouncements();

  Future<Result<List<Embassy>, Exception>> getUserEmbassys(String userId);
}

/// Exception thrown when there is no internet connection.
class NoConnectionException implements Exception {}

/// Exception thrown when the default company is used.
class DefaultCompanyException implements Exception {}

/// Exception thrown when the authentication token is not found.
class TokenNotFoundException implements Exception {}
