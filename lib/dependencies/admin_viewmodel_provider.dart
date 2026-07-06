import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_ambassadors_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_badges_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_banners_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_exchanges_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_feeds_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_news_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_permissions_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_rewards_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_users_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_zones_repository.dart';
import 'package:bondly_app/features/admin/domain/usecases/get_admin_permissions_usecase.dart';
import 'package:bondly_app/features/admin/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_ambassadors_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_badges_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_banners_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_dashboard_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_exchanges_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_feeds_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_news_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_permissions_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_reports_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_rewards_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_shell_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_users_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_zones_viewmodel.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';

class AdminViewModelProvider {
  static void provide() {
    getIt.registerFactory<AdminShellViewModel>(
      () => AdminShellViewModel(
        getIt<UserUseCase>(),
        getIt<GetAdminPermissionsUseCase>(),
      ),
    );
    getIt.registerFactory<AdminDashboardViewModel>(
      () => AdminDashboardViewModel(
        getIt<GetDashboardStatsUseCase>(),
        getIt<GetRecognitionTrendsUseCase>(),
        getIt<GetBadgeUsageReportUseCase>(),
      ),
    );
    getIt.registerFactory<AdminUsersViewModel>(
      () => AdminUsersViewModel(
        getIt<SupabaseAdminUsersRepository>(),
        getIt<SupabaseAdminZonesRepository>(),
      ),
    );
    getIt.registerFactory<AdminBadgesViewModel>(
      () => AdminBadgesViewModel(getIt<SupabaseAdminBadgesRepository>()),
    );
    getIt.registerFactory<AdminRewardsViewModel>(
      () => AdminRewardsViewModel(getIt<SupabaseAdminRewardsRepository>()),
    );
    getIt.registerFactory<AdminExchangesViewModel>(
      () => AdminExchangesViewModel(getIt<SupabaseAdminExchangesRepository>()),
    );
    getIt.registerFactory<AdminBannersViewModel>(
      () => AdminBannersViewModel(getIt<SupabaseAdminBannersRepository>()),
    );
    getIt.registerFactory<AdminNewsViewModel>(
      () => AdminNewsViewModel(getIt<SupabaseAdminNewsRepository>()),
    );
    getIt.registerFactory<AdminAmbassadorsViewModel>(
      () => AdminAmbassadorsViewModel(
          getIt<SupabaseAdminAmbassadorsRepository>()),
    );
    getIt.registerFactory<AdminReportsViewModel>(
      () => AdminReportsViewModel(
        getIt<GetRecognitionTrendsUseCase>(),
        getIt<GetBadgeUsageReportUseCase>(),
        getIt<SupabaseAdminExchangesRepository>(),
      ),
    );
    getIt.registerFactory<AdminZonesViewModel>(
      () => AdminZonesViewModel(getIt<SupabaseAdminZonesRepository>()),
    );
    getIt.registerFactory<AdminPermissionsViewModel>(
      () => AdminPermissionsViewModel(
          getIt<SupabaseAdminPermissionsRepository>()),
    );
    getIt.registerFactory<AdminFeedsViewModel>(
      () => AdminFeedsViewModel(getIt<SupabaseAdminFeedsRepository>()),
    );
  }
}
