import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/data/mappers/user_entity_mapper.dart';
import 'package:bondly_app/features/auth/data/repositories/api/auth_api.dart';
import 'package:bondly_app/features/auth/data/repositories/api/users_api.dart';
import 'package:bondly_app/features/auth/data/repositories/default_auth_repository.dart';
import 'package:bondly_app/features/auth/data/repositories/default_users_repository.dart';
import 'package:bondly_app/features/auth/data/repositories/remote_users_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/home/data/repositories/api/akcnowledgments_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/badges_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/banners_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/categories_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/company_collaborators.dart';
import 'package:bondly_app/features/home/data/repositories/api/company_feeds_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/create_comment_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/handle_like_api.dart';
import 'package:bondly_app/features/home/data/repositories/default_banners_repository.dart';
import 'package:bondly_app/features/home/data/repositories/default_company_feeds_repository.dart';
import 'package:bondly_app/features/home/domain/repositories/banners_repository.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:bondly_app/features/profile/data/repositories/default_activity_repository.dart';
import 'package:bondly_app/features/profile/domain/repositories/activity_repository.dart';
import 'package:bondly_app/features/storage/data/local/bondly_database.dart';
import 'package:bondly_app/features/storage/data/local/dao/users_dao.dart';

class RepositoryProvider {
  static provide() {
    // This probably could be a factory
    getIt.registerSingleton<AuthRepository>(
      DefaultAuthRepository(getIt<AuthAPI>()),
    );

    getIt.registerSingleton<BannersRepository>(
      DefaultBannersRepository(getIt<BannersAPI>())
    );

    getIt.registerSingleton<CompanyFeedsRepository>(
      DefaultCompanyFeedsRespository(getIt<CompanyFeedsAPI>(),
        getIt<CreateCommentAPI>(),
        getIt<HandleLikeAPI>(),
        getIt<CategoriesAPI>(),
        getIt<BadgesAPI>(),
        getIt<CompanyCollaboratorsAPI>(),
        getIt<CreateAcknowledgmentAPI>()
      )
    );

    getIt.registerSingletonWithDependencies<UsersRepository>(
      () => DefaultUsersRepository(
          getIt<UsersDao>(),
          UserEntityMapper(),
        ),
        instanceName: DefaultUsersRepository.name,
        dependsOn: [AppDatabase, UsersDao]
    );

    getIt.registerSingletonAsync<UsersRepository>(
      () async => RemoteUsersRepository(getIt<UsersAPI>()),
        instanceName: RemoteUsersRepository.name
    );

    getIt.registerSingleton<ActivityRepository>(
      DefaultActivityRepository(getIt<UsersAPI>())
    );


  }
}