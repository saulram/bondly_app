import 'package:bondly_app/features/home/data/repositories/api/company_feeds_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/create_comment_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/handle_like_api.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:multiple_result/multiple_result.dart';

/// A repository implementation for fetching default banners from the server.
/// This class implements the [BannersRepository] abstract class.
/// It uses the [_bannersAPI] instance to fetch the banners from the server.
/// If an exception occurs during the API call, it returns a [Result] object with an [NoConnectionException] error.
class DefaultCompanyFeedsRespository extends CompanyFeedsRepository {
  final CompanyFeedsAPI _feedsAPI;
  final CreateCommentAPI _createCommentAPI;
  final HandleLikeAPI _handleLikeAPI;

  DefaultCompanyFeedsRespository(
      this._feedsAPI, this._createCommentAPI, this._handleLikeAPI);
  @override
  Future<Result<CompanyFeed, Exception>> getCompanyFeeds() async {
    try {
      return Result.success(await _feedsAPI.getCompanyFeeds());
    } catch (exception) {
      if (exception is TokenNotFoundException) {
        return Result.error(exception);
      }

      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<FeedData, Exception>> createComment(
      String feedId, String message) async {
    try {
      return Result.success(
          await _createCommentAPI.createComment(feedId, message));
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<bool, Exception>> likePost(String feedId) async {
    try {
      return Result.success(await _handleLikeAPI.handlelike(feedId));
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }
}
