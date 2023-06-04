import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:bondly_app/src/routes.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.I;

class DependencyManager {
  Future<void> initialize() async {
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
  }

  Future<void> dispose() async {
    return await getIt.reset(dispose: true);
  }
}
