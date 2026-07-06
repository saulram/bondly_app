import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_ambassadors_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_auth_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_badges_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_banners_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_exchanges_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_feeds_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_news_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_permissions_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_rewards_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_users_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_zones_repository.dart';
import 'package:bondly_app/features/admin/domain/repositories/admin_auth_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';

class AdminRepositoryProvider {
  static void provide() {
    getIt.registerSingleton<AdminAuthRepository>(
      SupabaseAdminAuthRepository(getIt<SupabaseClientProvider>()),
    );
    getIt.registerSingleton<SupabaseAdminUsersRepository>(
      SupabaseAdminUsersRepository(getIt<SupabaseClientProvider>()),
    );
    getIt.registerSingleton<SupabaseAdminBadgesRepository>(
      SupabaseAdminBadgesRepository(getIt<SupabaseClientProvider>()),
    );
    getIt.registerSingleton<SupabaseAdminRewardsRepository>(
      SupabaseAdminRewardsRepository(getIt<SupabaseClientProvider>()),
    );
    getIt.registerSingleton<SupabaseAdminExchangesRepository>(
      SupabaseAdminExchangesRepository(getIt<SupabaseClientProvider>()),
    );
    getIt.registerSingleton<SupabaseAdminBannersRepository>(
      SupabaseAdminBannersRepository(getIt<SupabaseClientProvider>()),
    );
    getIt.registerSingleton<SupabaseAdminNewsRepository>(
      SupabaseAdminNewsRepository(getIt<SupabaseClientProvider>()),
    );
    getIt.registerSingleton<SupabaseAdminAmbassadorsRepository>(
      SupabaseAdminAmbassadorsRepository(getIt<SupabaseClientProvider>()),
    );
    getIt.registerSingleton<SupabaseAdminZonesRepository>(
      SupabaseAdminZonesRepository(getIt<SupabaseClientProvider>()),
    );
    getIt.registerSingleton<SupabaseAdminPermissionsRepository>(
      SupabaseAdminPermissionsRepository(getIt<SupabaseClientProvider>()),
    );
    getIt.registerSingleton<SupabaseAdminFeedsRepository>(
      SupabaseAdminFeedsRepository(getIt<SupabaseClientProvider>()),
    );
  }
}
