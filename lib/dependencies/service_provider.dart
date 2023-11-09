import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/src/app_services.dart';

class ServiceProvider {
  static provide() {
    getIt.registerSingleton<AppServices>(
      AppServices(),
    );
  }
}
