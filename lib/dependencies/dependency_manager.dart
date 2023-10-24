import 'package:bondly_app/features/auth/data/handlers/auth_session_token_handler.dart';
import 'package:bondly_app/features/auth/data/mappers/user_entity_mapper.dart';
import 'package:bondly_app/features/auth/data/repositories/api/auth_api.dart';
import 'package:bondly_app/features/auth/data/repositories/api/users_api.dart';
import 'package:bondly_app/features/auth/data/repositories/default_auth_repository.dart';
import 'package:bondly_app/features/auth/data/repositories/default_users_repository.dart';
import 'package:bondly_app/features/auth/data/repositories/remote_users_repository.dart';
import 'package:bondly_app/features/auth/domain/handlers/session_token_handler.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/get_login_companies_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_state_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_viewmodel.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
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
import 'package:bondly_app/features/home/domain/usecases/create_feed_comment.dart';
import 'package:bondly_app/features/home/domain/usecases/get_category_badges.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_banners.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_categories.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_collaborators.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_feeds.dart';
import 'package:bondly_app/features/home/domain/usecases/handle_like.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:bondly_app/features/profile/domain/update_user_avatar_usecase.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/profile_viewmodel.dart';
import 'package:bondly_app/features/storage/data/local/bondly_database.dart';
import 'package:bondly_app/features/storage/data/local/dao/users_dao.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:bondly_app/src/routes.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.I;

class DependencyManager {
  Future<void> initialize() async {
    await registerStorageObjects();
    registerSessionTokenHandler();
    registerApiHandler();
    provideApis();
    provideRepositories();
    provideUseCases();
    provideModels();
    await getIt.allReady();
  }

  Future<void> registerStorageObjects() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    getIt.registerSingletonAsync<AppDatabase>(
            () async => $FloorAppDatabase.databaseBuilder('bondly.db').build());

    getIt.registerSingletonWithDependencies<UsersDao>(() {
      return getIt<AppDatabase>().usersDao;
    }, dependsOn: [AppDatabase]);
  }

  void registerSessionTokenHandler() {
    getIt.registerSingleton<SessionTokenHandler>(
        AuthSessionTokenHandler(getIt<SharedPreferences>()));
  }

  void provideModels() {
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
            ),
        dependsOn: [UserUseCase]);
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
  }

  void registerApiHandler() {
    getIt.registerSingleton<ApiCallsHandler>(
      //TO-DO: Fetch these values from right place
        ApiCallsHandler(
            appVersion: "1",
            buildNumber: "1",
            sessionTokenHandler: getIt<SessionTokenHandler>()));
  }

  void provideApis() {
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
      UsersAPI(getIt<ApiCallsHandler>()),
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
  }

  void provideRepositories() {
    // This probably could be a factory
    getIt.registerSingleton<AuthRepository>(
      DefaultAuthRepository(getIt<AuthAPI>()),
    );
    getIt.registerSingleton<BannersRepository>(
        DefaultBannersRepository(getIt<BannersAPI>()));

    getIt.registerSingleton<CompanyFeedsRepository>(
        DefaultCompanyFeedsRespository(getIt<CompanyFeedsAPI>(),
            getIt<CreateCommentAPI>(), getIt<HandleLikeAPI>(),
          getIt<CategoriesAPI>(),getIt<BadgesAPI>(),getIt<CompanyCollaboratorsAPI>()
          ));

    getIt.registerSingletonWithDependencies<UsersRepository>(
            () => DefaultUsersRepository(
          getIt<UsersDao>(),
          UserEntityMapper(),
        ),
        instanceName: DefaultUsersRepository.name,
        dependsOn: [AppDatabase, UsersDao]);

    getIt.registerSingletonAsync<UsersRepository>(
            () async => RemoteUsersRepository(getIt<UsersAPI>()),
        instanceName: RemoteUsersRepository.name
    );
  }

  void provideUseCases() {
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<GetCompaniesUseCase>(
      GetCompaniesUseCase(getIt<AuthRepository>()),
    );
    getIt.registerSingleton<GetCompanyBannersUseCase>(
        GetCompanyBannersUseCase(getIt<BannersRepository>()));

    getIt.registerSingleton<GetCompanyFeedsUseCase>(
        GetCompanyFeedsUseCase(getIt<CompanyFeedsRepository>()));

    getIt.registerSingleton<CreateFeedCommentUseCase>(
        CreateFeedCommentUseCase(getIt<CompanyFeedsRepository>()));

    getIt.registerSingleton<HandleLikesUseCase>(
        HandleLikesUseCase(getIt<CompanyFeedsRepository>()));

    getIt.registerSingleton<GetLoginStateUseCase>(
        GetLoginStateUseCase(getIt<SharedPreferences>()));
    getIt.registerSingleton<GetCompanyCollaboratorsUseCase>(
        GetCompanyCollaboratorsUseCase(getIt<CompanyFeedsRepository>()));
    getIt.registerSingleton<GetCategoriesUseCase>(
        GetCategoriesUseCase(getIt<CompanyFeedsRepository>()));
    getIt.registerSingleton<GetCategoryBadgesUseCase>(
        GetCategoryBadgesUseCase(getIt<CompanyFeedsRepository>()));

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
  }

  Future<void> dispose() async {
    return await getIt.reset(dispose: true);
  }
}
