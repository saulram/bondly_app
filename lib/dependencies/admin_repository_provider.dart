import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_auth_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_badges_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_banners_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_exchanges_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_news_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_rewards_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_users_repository.dart';
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
  }
}
