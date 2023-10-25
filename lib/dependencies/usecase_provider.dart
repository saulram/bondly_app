import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/data/repositories/default_users_repository.dart';
import 'package:bondly_app/features/auth/data/repositories/remote_users_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/get_login_companies_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_state_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/home/domain/repositories/banners_repository.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:bondly_app/features/home/domain/usecases/create_acknowlegment.dart';
import 'package:bondly_app/features/home/domain/usecases/create_feed_comment.dart';
import 'package:bondly_app/features/home/domain/usecases/get_category_badges.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_banners.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_categories.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_collaborators.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_feeds.dart';
import 'package:bondly_app/features/home/domain/usecases/handle_like.dart';
import 'package:bondly_app/features/profile/domain/repositories/activity_repository.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_user_activity_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/update_user_avatar_usecase.dart';
import 'package:bondly_app/features/storage/data/local/bondly_database.dart';
import 'package:bondly_app/features/storage/data/local/dao/users_dao.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UseCaseProvider {
  static void provide() {
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<GetCompaniesUseCase>(
      GetCompaniesUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<GetCompanyBannersUseCase>(
        GetCompanyBannersUseCase(getIt<BannersRepository>())
    );

    getIt.registerSingleton<GetCompanyFeedsUseCase>(
        GetCompanyFeedsUseCase(getIt<CompanyFeedsRepository>())
    );

    getIt.registerSingleton<CreateFeedCommentUseCase>(
        CreateFeedCommentUseCase(getIt<CompanyFeedsRepository>())
    );

    getIt.registerSingleton<HandleLikesUseCase>(
        HandleLikesUseCase(getIt<CompanyFeedsRepository>())
    );

    getIt.registerSingleton<GetLoginStateUseCase>(
        GetLoginStateUseCase(getIt<SharedPreferences>())
    );

    getIt.registerSingleton<GetCompanyCollaboratorsUseCase>(
        GetCompanyCollaboratorsUseCase(getIt<CompanyFeedsRepository>())
    );

    getIt.registerSingleton<GetCategoriesUseCase>(
        GetCategoriesUseCase(getIt<CompanyFeedsRepository>())
    );

    getIt.registerSingleton<GetCategoryBadgesUseCase>(
        GetCategoryBadgesUseCase(getIt<CompanyFeedsRepository>())
    );

    getIt.registerSingletonWithDependencies(
        () => UserUseCase(
          getIt<UsersRepository>(instanceName: DefaultUsersRepository.name),
          getIt<UsersRepository>(instanceName: RemoteUsersRepository.name)
        ),
        dependsOn: [
          AppDatabase,
          UsersDao,
          InitDependency(UsersRepository, instanceName: DefaultUsersRepository.name),
          InitDependency(UsersRepository, instanceName: RemoteUsersRepository.name)
        ]
    );

    getIt.registerSingletonWithDependencies(
        () => LogoutUseCase(
          sharedPreferences: getIt<SharedPreferences>(),
          usersRepository: getIt<UsersRepository>(instanceName: DefaultUsersRepository.name)
        ),
        dependsOn: [
          AppDatabase,
          UsersDao,
          InitDependency(UsersRepository, instanceName: DefaultUsersRepository.name)
        ]
    );

    getIt.registerSingletonWithDependencies(
        () => UpdateUserAvatarUseCase(
          getIt<UsersRepository>(instanceName: RemoteUsersRepository.name)
        ),
        dependsOn: [
          AppDatabase,
          UsersDao,
          InitDependency(UsersRepository, instanceName: RemoteUsersRepository.name)
        ]
    );

    getIt.registerSingleton<GetUserActivityUseCase>(
        GetUserActivityUseCase(getIt<ActivityRepository>())
    );

    getIt.registerSingleton<CreateAcknowledgmentUseCase>(
        CreateAcknowledgmentUseCase(getIt<CompanyFeedsRepository>())
    );
  }
}