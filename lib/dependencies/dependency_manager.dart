import 'package:bondly_app/features/auth/data/repositories/api/auth_api.dart';
import 'package:bondly_app/features/auth/data/repositories/default_login_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/login_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_view_model.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:bondly_app/src/routes.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.I;

class DependencyManager {
  Future<void> initialize() async {
    registerApiHandler();
    provideApis();
    provideRepositories();
    provideUseCases();
    provideModels();
    await getIt.allReady();
  }

  void provideModels() {
    getIt.registerSingleton<AppRouter>(AppRouter());
    getIt.registerSingleton<NavigationModel>(NavigationModel());
    getIt.registerSingletonAsync<SharedPreferences>(
        () => SharedPreferences.getInstance());
    getIt.registerSingletonWithDependencies<AppModel>(
        () => AppModel(getIt<SharedPreferences>()),
        dependsOn: [SharedPreferences]);

    getIt.registerSingletonWithDependencies<LoginViewModel>(
        () => LoginViewModel(
          getIt<AppModel>()
      ),
      dependsOn: [AppModel]
    );
  }

  void registerApiHandler() {
    getIt.registerSingleton<ApiCallsHandler>(
      //TO-DO: Fetch this from right place
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
    getIt.registerSingleton<LoginRepository>(
      DefaultLoginRepository(getIt<AuthAPI>()),
    );
  }

  void provideUseCases() {
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(getIt<LoginRepository>()),
    );
  }

  Future<void> dispose() async {
    return await getIt.reset(dispose: true);
  }
}
