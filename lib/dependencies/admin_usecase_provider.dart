import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/repositories/admin_auth_repository.dart';
import 'package:bondly_app/features/admin/domain/usecases/check_admin_access_usecase.dart';
import 'package:bondly_app/features/admin/domain/usecases/get_admin_permissions_usecase.dart';
import 'package:bondly_app/features/admin/domain/usecases/get_dashboard_stats_usecase.dart';

class AdminUseCaseProvider {
  static void provide() {
    getIt.registerSingleton<CheckAdminAccessUseCase>(
      CheckAdminAccessUseCase(getIt<AdminAuthRepository>()),
    );
    getIt.registerSingleton<GetAdminPermissionsUseCase>(
      GetAdminPermissionsUseCase(getIt<AdminAuthRepository>()),
    );
    getIt.registerSingleton<GetDashboardStatsUseCase>(
      GetDashboardStatsUseCase(getIt<AdminAuthRepository>()),
    );
    getIt.registerSingleton<GetRecognitionTrendsUseCase>(
      GetRecognitionTrendsUseCase(getIt<AdminAuthRepository>()),
    );
    getIt.registerSingleton<GetBadgeUsageReportUseCase>(
      GetBadgeUsageReportUseCase(getIt<AdminAuthRepository>()),
    );
  }
}
