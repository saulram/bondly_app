import 'package:bondly_app/features/auth/data/mappers/user_entity_mapper.dart';
import 'package:bondly_app/features/auth/data/repositories/api/auth_api.dart';
import 'package:bondly_app/features/auth/data/repositories/default_auth_repository.dart';
import 'package:bondly_app/features/auth/data/repositories/default_users_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/get_login_companies_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_state_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/session_token_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_viewmodel.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/data/repositories/api/banners_api.dart';
import 'package:bondly_app/features/home/data/repositories/default_banners_repository.dart';
import 'package:bondly_app/features/home/domain/repositories/banners_repository.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_banners.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:bondly_app/features/storage/data/local/bondly_database.dart';
import 'package:bondly_app/features/storage/data/local/dao/users_dao.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:bondly_app/src/routes.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.I;

class DependencyManager {
  Future<void> initialize() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    registerDatabaseObjects();
    registerApiHandler();
    provideApis(sharedPreferences);
    provideRepositories();
    provideUseCases(sharedPreferences);
    provideModels();
    await getIt.allReady();
  }

  void registerDatabaseObjects() {
    getIt.registerSingletonAsync<AppDatabase>(
        () async => $FloorAppDatabase.databaseBuilder('bondly.db').build());

    getIt.registerSingletonWithDependencies<UsersDao>(() {
      return getIt<AppDatabase>().usersDao;
    }, dependsOn: [AppDatabase]);
  }

  void provideModels() {
    getIt.registerSingleton<AppRouter>(AppRouter());
    getIt.registerSingleton<NavigationModel>(NavigationModel());
    getIt.registerSingleton<AppModel>(AppModel());
    getIt.registerSingletonWithDependencies<HomeViewModel>(
        () => HomeViewModel(getIt<UserUseCase>(), getIt<SessionTokenUseCase>(),
            getIt<GetCompanyBannersUseCase>()),
        dependsOn: [UserUseCase]);
    getIt.registerSingletonWithDependencies<LoginViewModel>(
        () => LoginViewModel(
              getIt<LoginUseCase>(),
              getIt<GetCompaniesUseCase>(),
              getIt<GetLoginStateUseCase>(),
              getIt<UserUseCase>(),
              getIt<SessionTokenUseCase>(),
            ),
        dependsOn: [AppDatabase, UsersDao, UsersRepository, UserUseCase]);
  }

  void registerApiHandler() {
    getIt.registerSingleton<ApiCallsHandler>(
        //TO-DO: Fetch these values from right place
        ApiCallsHandler("1", "1"));
  }

  void provideApis(SharedPreferences sharedPreferences) {
    getIt.registerSingleton<AuthAPI>(
      AuthAPI(getIt<ApiCallsHandler>()),
    );
    getIt.registerSingleton<BannersAPI>(
      BannersAPI(
          authToken: sharedPreferences.getString(SessionTokenUseCase.tokenKey),
          getIt<ApiCallsHandler>()
      ),
    );
  }

  void provideRepositories() {
    // This probably could be a factory
    getIt.registerSingleton<AuthRepository>(
      DefaultAuthRepository(getIt<AuthAPI>()),
    );
    getIt.registerSingleton<BannersRepository>(
        DefaultBannersRepository(getIt<BannersAPI>()));

    getIt.registerSingletonWithDependencies<UsersRepository>(
        () => DefaultUsersRepository(
              getIt<UsersDao>(),
              UserEntityMapper(),
            ),
        dependsOn: [AppDatabase, UsersDao]);
  }

  void provideUseCases(SharedPreferences sharedPreferences) {
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<GetCompaniesUseCase>(
      GetCompaniesUseCase(getIt<AuthRepository>()),
    );
    getIt.registerSingleton<GetCompanyBannersUseCase>(
        GetCompanyBannersUseCase(getIt<BannersRepository>()));

    getIt.registerSingleton<GetLoginStateUseCase>(
        GetLoginStateUseCase(getIt<SharedPreferences>()));

    getIt.registerSingleton<SessionTokenUseCase>(
        SessionTokenUseCase(getIt<SharedPreferences>()));

    getIt.registerSingletonWithDependencies(
        () => UserUseCase(getIt<UsersRepository>()),
        dependsOn: [AppDatabase, UsersDao, UsersRepository]);
  }

  Future<void> dispose() async {
    return await getIt.reset(dispose: true);
  }
}
