import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/data/repositories/api/auth_api.dart';
import 'package:bondly_app/features/auth/data/repositories/api/mappers/user_activity_response_mapper.dart';
import 'package:bondly_app/features/auth/data/repositories/api/users_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/akcnowledgments_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/badges_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/banners_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/categories_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/company_collaborators.dart';
import 'package:bondly_app/features/home/data/repositories/api/company_feeds_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/create_comment_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/handle_like_api.dart';
import 'package:bondly_app/src/api_calls_handler.dart';

class APIProvider {
  static provide() {
    getIt.registerSingleton<AuthAPI>(
      AuthAPI(getIt<ApiCallsHandler>()),
    );

    getIt.registerSingleton<BannersAPI>(
      BannersAPI(getIt<ApiCallsHandler>()),
    );

    getIt.registerSingleton<CompanyFeedsAPI>(
      CompanyFeedsAPI(getIt<ApiCallsHandler>()),
    );

    getIt.registerSingleton<CreateCommentAPI>(
      CreateCommentAPI(getIt<ApiCallsHandler>()),
    );

    getIt.registerSingleton<HandleLikeAPI>(
      HandleLikeAPI(getIt<ApiCallsHandler>()),
    );

    getIt.registerSingleton<UsersAPI>(
      UsersAPI(
          getIt<ApiCallsHandler>(),
          UserActivityResponseMapper()
      ),
    );

    getIt.registerSingleton<CategoriesAPI>(
      CategoriesAPI(getIt<ApiCallsHandler>()),
    );

    getIt.registerSingleton<BadgesAPI>(
      BadgesAPI(getIt<ApiCallsHandler>()),
    );

    getIt.registerSingleton<CompanyCollaboratorsAPI>(
      CompanyCollaboratorsAPI(getIt<ApiCallsHandler>()),
    );

    getIt.registerSingleton<CreateAcknowledgmentAPI>(
      CreateAcknowledgmentAPI(getIt<ApiCallsHandler>()),
    );
  }
}