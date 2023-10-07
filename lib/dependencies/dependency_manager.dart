import 'package:bondly_app/features/auth/data/repositories/api/auth_api.dart';
import 'package:bondly_app/features/auth/data/repositories/default_auth_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/get_login_companies_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_state_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_viewmodel.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:bondly_app/src/routes.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.I;

class DependencyManager {
  Future<void> initialize() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    registerApiHandler();
    provideApis();
    provideRepositories();
    provideUseCases(sharedPreferences);
    provideModels();
    await getIt.allReady();
  }

  void provideModels() {
    getIt.registerSingleton<AppRouter>(AppRouter());
    getIt.registerSingleton<NavigationModel>(NavigationModel());
    getIt.registerSingleton<AppModel>(AppModel());
    getIt.registerSingleton<LoginViewModel>(
      LoginViewModel(
        getIt<LoginUseCase>(),
        getIt<GetCompaniesUseCase>(),
        getIt<GetLoginStateUseCase>(),
      )
    );
  }

  void registerApiHandler() {
    getIt.registerSingleton<ApiCallsHandler>(
      //TO-DO: Fetch these values from right place
      ApiCallsHandler("1", "1")
    );
  }

  void provideApis() {
    getIt.registerSingleton<AuthAPI>(
      AuthAPI(getIt<ApiCallsHandler>()),
    );
  }

  void provideRepositories() {
    // This probably could be a factory
    getIt.registerSingleton<AuthRepository>(
      DefaultAuthRepository(getIt<AuthAPI>()),
    );
  }

  void provideUseCases(SharedPreferences sharedPreferences) {
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<GetCompaniesUseCase>(
      GetCompaniesUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<GetLoginStateUseCase>(
      GetLoginStateUseCase(getIt<SharedPreferences>())
    );
  }

  Future<void> dispose() async {
    return await getIt.reset(dispose: true);
  }
}
