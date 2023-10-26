import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/data/repositories/default_users_repository.dart';
import 'package:bondly_app/features/auth/domain/handlers/session_token_handler.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/get_login_companies_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_state_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_viewmodel.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/domain/usecases/create_acknowlegment.dart';
import 'package:bondly_app/features/home/domain/usecases/create_feed_comment.dart';
import 'package:bondly_app/features/home/domain/usecases/get_category_badges.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_banners.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_categories.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_collaborators.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_feeds.dart';
import 'package:bondly_app/features/home/domain/usecases/handle_like.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_user_activity_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/update_user_avatar_usecase.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/my_activity_viewmodel.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/profile_viewmodel.dart';
import 'package:bondly_app/features/storage/data/local/bondly_database.dart';
import 'package:bondly_app/features/storage/data/local/dao/users_dao.dart';
import 'package:bondly_app/src/routes.dart';
import 'package:get_it/get_it.dart';

class ViewModelProvider {
  static provide() {
    getIt.registerSingleton<AppRouter>(AppRouter());

    getIt.registerSingleton<NavigationModel>(NavigationModel());

    getIt.registerSingleton<AppModel>(AppModel());

    getIt.registerSingletonWithDependencies<ProfileViewModel>(
            () => ProfileViewModel(
          userUseCase: getIt<UserUseCase>(),
          logoutUseCase: getIt<LogoutUseCase>(),
          updateUserUseCase: getIt<UpdateUserAvatarUseCase>(),
        ),
        dependsOn: [
          AppDatabase,
          UsersDao,
          LogoutUseCase,
          InitDependency(UsersRepository, instanceName: DefaultUsersRepository.name),
        ]
    );

    getIt.registerSingletonWithDependencies<HomeViewModel>(
            () => HomeViewModel(
          getIt<UserUseCase>(),
          getIt<SessionTokenHandler>(),
          getIt<GetCompanyBannersUseCase>(),
          getIt<GetCompanyFeedsUseCase>(),
          getIt<CreateFeedCommentUseCase>(),
          getIt<HandleLikesUseCase>(),
          getIt<GetCategoriesUseCase>(),
          getIt<GetCategoryBadgesUseCase>(),
          getIt<GetCompanyCollaboratorsUseCase>(),
          getIt<CreateAcknowledgmentUseCase>()
        ),
        dependsOn: [UserUseCase]
    );

    getIt.registerSingletonWithDependencies<LoginViewModel>(
            () => LoginViewModel(
          getIt<LoginUseCase>(),
          getIt<GetCompaniesUseCase>(),
          getIt<GetLoginStateUseCase>(),
          getIt<UserUseCase>(),
          getIt<SessionTokenHandler>(),
        ),
        dependsOn: [
          AppDatabase,
          UsersDao,
          UserUseCase,
          InitDependency(UsersRepository, instanceName: DefaultUsersRepository.name),
        ]
    );

    getIt.registerFactory<MyActivityViewModel>(
        () => MyActivityViewModel(
          getIt<GetUserActivityUseCase>(),
          getIt<UserUseCase>(),
          getIt<LogoutUseCase>()
        )
    );
  }
}