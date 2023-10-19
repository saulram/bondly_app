import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:multiple_result/multiple_result.dart';

/// This file contains the [CompanyFeedsRepository] abstract class and several exception classes.
/// The [CompanyFeedsRepository] class defines the contract for retrieving company banners.
/// The exception classes are used to handle different error scenarios that may occur during the login process.
abstract class CompanyFeedsRepository {
  /// Retrieves the company banners.
  ///
  /// Returns a [Result] object that contains either the [List<FeedPost>] or an [Exception].
  Future<Result<CompanyFeed, Exception>> getCompanyFeeds();
  Future<Result<FeedData, Exception>> createComment(
      String feedId, String message);
  Future<Result<bool, Exception>> likePost(String feedId);
}

/// Exception thrown when there is no internet connection.
class NoConnectionException implements Exception {}

/// Exception thrown when the default company is used.
class DefaultCompanyException implements Exception {}

/// Exception thrown when the authentication token is not found.
class TokenNotFoundException implements Exception {}
