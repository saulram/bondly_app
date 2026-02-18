import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/src/app_services.dart';
import 'package:bondly_app/src/push_notification_service.dart';

class ServiceProvider {
  static void provide() {
    getIt.registerSingleton<AppServices>(
      AppServices(),
    );

    getIt.registerSingleton<PushNotificationService>(
      PushNotificationService(),
    );
  }
}
