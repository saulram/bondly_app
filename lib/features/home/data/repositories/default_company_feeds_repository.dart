import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/home/data/repositories/api/badges_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/categories_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/company_collaborators.dart';
import 'package:bondly_app/features/home/data/repositories/api/company_feeds_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/create_comment_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/handle_like_api.dart';
import 'package:bondly_app/features/home/domain/models/category_badges.dart';
import 'package:bondly_app/features/home/domain/models/company_categories.dart';
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
  final CategoriesAPI _categoriesAPI;
  final BadgesAPI _badgesAPI;
  final CompanyCollaboratorsAPI _companyCollaboratorsAPI;

  DefaultCompanyFeedsRespository(
      this._feedsAPI,
      this._createCommentAPI,
      this._handleLikeAPI,
      this._categoriesAPI,
      this._badgesAPI,
      this._companyCollaboratorsAPI);
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

  @override
  Future<Result<Badges, Exception>> getBadges(String categoryId) async {
    try {
      return Result.success(await _badgesAPI.getCategoryBadges(categoryId));
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<Categories, Exception>> getCategories() async {
    try {
      return Result.success(await _categoriesAPI.getCompanyCategories());
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<List<User>, Exception>> getCompanyCollaborators() async {
    try {
      return Result.success(
          await _companyCollaboratorsAPI.getCompanyCollaborator());
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }
}
