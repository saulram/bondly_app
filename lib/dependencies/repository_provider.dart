import 'package:bondly_app/config/backend_config.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/ai/data/api/gemini_service.dart';
import 'package:bondly_app/features/ai/data/repositories/default_ai_repository.dart';
import 'package:bondly_app/features/ai/domain/repositories/ai_repository.dart';
import 'package:bondly_app/features/auth/data/mappers/user_entity_mapper.dart';
import 'package:bondly_app/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:bondly_app/features/auth/data/repositories/supabase_users_repository.dart';
import 'package:bondly_app/features/base/data/repositories/default_supabase_repository.dart';
import 'package:bondly_app/features/base/domain/repositories/supabase_repository.dart';
import 'package:bondly_app/features/home/data/repositories/supabase_banners_repository.dart';
import 'package:bondly_app/features/home/data/repositories/supabase_company_feeds_repository.dart';
import 'package:bondly_app/features/profile/data/repositories/supabase_account_statement_repository.dart';
import 'package:bondly_app/features/profile/data/repositories/supabase_activity_repository.dart';
import 'package:bondly_app/features/profile/data/repositories/supabase_bondly_badges_repository.dart';
import 'package:bondly_app/features/profile/data/repositories/supabase_cart_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:bondly_app/features/auth/data/repositories/api/auth_api.dart';
import 'package:bondly_app/features/auth/data/repositories/api/users_api.dart';
import 'package:bondly_app/features/auth/data/repositories/default_auth_repository.dart';
import 'package:bondly_app/features/auth/data/repositories/default_users_repository.dart';
import 'package:bondly_app/features/auth/data/repositories/remote_users_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/home/data/repositories/api/akcnowledgments_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/ambassadors_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/announcements_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/badges_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/banners_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/categories_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/company_collaborators.dart';
import 'package:bondly_app/features/home/data/repositories/api/company_feeds_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/create_comment_api.dart';
import 'package:bondly_app/features/home/data/repositories/api/handle_like_api.dart';
import 'package:bondly_app/features/home/data/repositories/default_banners_repository.dart';
import 'package:bondly_app/features/home/data/repositories/default_company_feeds_repository.dart';
import 'package:bondly_app/features/home/domain/repositories/banners_repository.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:bondly_app/features/profile/data/api/account_balance_api.dart';
import 'package:bondly_app/features/profile/data/api/bondly_badges_api.dart';
import 'package:bondly_app/features/profile/data/api/cart_api.dart';
import 'package:bondly_app/features/profile/data/repositories/default_account_statement_repository.dart';
import 'package:bondly_app/features/profile/data/repositories/default_activity_repository.dart';
import 'package:bondly_app/features/profile/data/repositories/default_bondly_badges_repository.dart';
import 'package:bondly_app/features/profile/data/repositories/default_cart_repository.dart';
import 'package:bondly_app/features/profile/domain/repositories/account_statement_repository.dart';
import 'package:bondly_app/features/profile/domain/repositories/activity_repository.dart';
import 'package:bondly_app/features/profile/domain/repositories/bondly_badges_repository.dart';
import 'package:bondly_app/features/profile/domain/repositories/cart_repository.dart';
import 'package:bondly_app/features/storage/data/local/bondly_database.dart';
import 'package:bondly_app/features/storage/data/local/dao/users_dao.dart';

class RepositoryProvider {
  static void provide() {
    if (BackendConfig.isSupabase) {
      getIt.registerSingleton<AuthRepository>(
        SupabaseAuthRepository(getIt<SupabaseClientProvider>()),
      );
    } else {
      getIt.registerSingleton<AuthRepository>(
        DefaultAuthRepository(getIt<AuthAPI>()),
      );
    }

    if (BackendConfig.isSupabase) {
      getIt.registerSingleton<BannersRepository>(
        SupabaseBannersRepository(getIt<SupabaseClientProvider>()),
      );
    } else {
      getIt.registerSingleton<BannersRepository>(
        DefaultBannersRepository(getIt<BannersAPI>()),
      );
    }

    if (BackendConfig.isSupabase) {
      getIt.registerSingleton<CompanyFeedsRepository>(
        SupabaseCompanyFeedsRepository(getIt<SupabaseClientProvider>()),
      );
    } else {
      getIt.registerSingleton<CompanyFeedsRepository>(
        DefaultCompanyFeedsRepository(
          getIt<CompanyFeedsAPI>(),
          getIt<CreateCommentAPI>(),
          getIt<HandleLikeAPI>(),
          getIt<CategoriesAPI>(),
          getIt<BadgesAPI>(),
          getIt<CompanyCollaboratorsAPI>(),
          getIt<CreateAcknowledgmentAPI>(),
          getIt<AnnouncementsAPI>(),
          getIt<AmbassadorsAPI>(),
        ),
      );
    }

    // Local cache always registered
    getIt.registerSingletonWithDependencies<UsersRepository>(
        () => DefaultUsersRepository(
              getIt<UsersDao>(),
              UserEntityMapper(),
            ),
        instanceName: DefaultUsersRepository.name,
        dependsOn: [AppDatabase, UsersDao]);

    // Conditional remote users repository (must be async to satisfy InitDependency in UseCaseProvider)
    if (BackendConfig.isSupabase) {
      getIt.registerSingletonAsync<UsersRepository>(
        () async => SupabaseUsersRepository(getIt<SupabaseClientProvider>()),
        instanceName: SupabaseUsersRepository.name,
      );
    } else {
      getIt.registerSingletonAsync<UsersRepository>(
          () async => RemoteUsersRepository(getIt<UsersAPI>()),
          instanceName: RemoteUsersRepository.name);
    }

    if (BackendConfig.isSupabase) {
      getIt.registerSingleton<ActivityRepository>(
        SupabaseActivityRepository(getIt<SupabaseClientProvider>()),
      );
    } else {
      getIt.registerSingleton<ActivityRepository>(
        DefaultActivityRepository(getIt<UsersAPI>()),
      );
    }

    if (BackendConfig.isSupabase) {
      getIt.registerSingleton<CartRepository>(
        SupabaseCartRepository(getIt<SupabaseClientProvider>()),
      );
    } else {
      getIt.registerSingleton<CartRepository>(
        DefaultCartRepository(getIt<CartAPI>()),
      );
    }

    if (BackendConfig.isSupabase) {
      getIt.registerSingleton<BondlyBadgesRepository>(
        SupabaseBondlyBadgesRepository(getIt<SupabaseClientProvider>()),
      );
    } else {
      getIt.registerSingleton<BondlyBadgesRepository>(
        DefaultBondlyBadgesRepository(getIt<BondlyBadgesAPI>()),
      );
    }

    if (BackendConfig.isSupabase) {
      getIt.registerSingleton<AccountStatementRepository>(
        SupabaseAccountStatementRepository(getIt<SupabaseClientProvider>()),
      );
    } else {
      getIt.registerSingleton<AccountStatementRepository>(
        DefaultAccountStatementRepository(getIt<AccountBalanceAPI>()),
      );
    }

    getIt.registerSingleton<SupabaseRepository>(
      DefaultSupabaseRepository(
        getIt<SupabaseClientProvider>(),
      ),
    );
    getIt.registerSingleton<AIRepository>(
      DefaultAIRepository(getIt<GeminiService>()),
    );
  }
}
