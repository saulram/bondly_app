# Bondly - Architecture Overview

## System Summary

Bondly is an HR rewards/recognition mobile app built with Flutter (Dart SDK >=3.5.0 <4.0.0) targeting Android, iOS, and Web. The current backend is a REST API (Node.js/Express/MongoDB) at `https://api.bondly.mx/api/`. A parallel Supabase backend is being developed.

---

## Backend Stack (Current)

- **Runtime:** Node.js
- **Framework:** Express.js v4.18.1
- **Database:** MongoDB via Mongoose v6.5.2 (MongoDB Atlas)
- **Deployment:** Vercel (serverless)
- **Auth:** JWT (jwt-simple), bcrypt password hashing, no token expiration
- **File uploads:** Multer (disk storage at `public/upload/`)
- **Scheduled jobs:** node-cron (2 monthly jobs)
- **API docs:** Swagger (swagger-jsdoc + swagger-ui-express)

### Backend Directory Structure
```
bondly_backend/
  index.js              # Entry: connects MongoDB, starts Express
  app.js                # Middleware/route wiring
  config/.env           # Environment variables
  models/               # 20 Mongoose schemas
  controllers/          # 19 controllers
  controllers/services/ # 12 service classes (business logic)
  routes/               # 18 route files
  middleware/            # JWT, multer, pagination
  swagger/              # API doc schemas
  public/upload/        # Uploaded files
```

---

## Frontend Stack (Flutter)

### Architecture: Clean Architecture with Feature-Based Modules

```
lib/
  main.dart                    # Entry point
  config/                      # Theme, colors, strings, environment, constants
  dependencies/                # GetIt DI wiring
  generated/                   # Generated asset constants
  src/                         # Shared infrastructure
    api_calls_handler.dart     # HTTP client wrapper
    routes.dart                # GoRouter route definitions
    app_services.dart          # Snackbar helper
    push_notification_service.dart  # Stubbed push service
    supabase_client_provider.dart   # Supabase client wrapper
    network_image_helpers.dart      # Image URL helpers
  features/
    auth/                      # Authentication
    home/                      # Feed, recognitions, banners, announcements
    profile/                   # Profile, rewards, cart, activity, badges
    ranking/                   # Leaderboards
    ai/                        # Gemini AI integration
    main/                      # AppModel, splash routing
    start/                     # Splash screen
    notifications/             # Notifications (placeholder)
    base/                      # Shared ViewModel base classes
    storage/                   # Floor SQLite local DB
```

Each feature follows:
```
features/<feature>/
  domain/
    models/        # Pure Dart models (manual fromJson/toJson)
    repositories/  # Abstract repository interfaces
    usecases/      # Single-purpose use cases with invoke()
  data/
    repositories/  # Concrete implementations + api/ for HTTP clients
    handlers/      # Concrete handler implementations
    mappers/       # Data-to-domain mapping
  ui/
    screens/       # Screen widgets
    viewmodels/    # ChangeNotifier-based ViewModels
    widgets/       # Feature-scoped widgets
    states/        # Sealed UI state classes
```

---

## State Management

Custom ViewModel pattern built on `ChangeNotifier` + `provider`:

1. **`DebouncedChangeNotifier`** - Coalesces `notifyListeners()` calls via microtask scheduling
2. **`ContextModel`** extends it with `BuildContext` awareness
3. **`NavigationModel`** extends it with `GoRouter` navigation and `busy` flag

Screens use `ModelProvider<T>` (injects model, sets context) wrapping `ModelBuilder<T>` (Consumer that rebuilds on notify).

Use cases return `Result<T, Exception>` from `multiple_result` package, consumed via `result.when((success) {}, (error) {})`.

UI states use sealed classes (e.g., `LoginUIState` with `LoadingLogin`, `SuccessLogin`, `FailedLogin` subtypes).

---

## Dependency Injection

Uses `get_it` as service locator. All wiring in `lib/dependencies/dependency_manager.dart`:

| Order | Provider | What |
|-------|----------|------|
| 0 | Inline | SupabaseClientProvider |
| 1 | StorageObjectsProvider | SharedPreferences, Floor AppDatabase, UsersDao |
| 2 | HandlersProvider | SessionTokenHandler, ApiCallsHandler |
| 3 | APIProvider | 15 API client singletons + GeminiService |
| 4 | RepositoryProvider | All repository bindings (conditional API vs Supabase) |
| 5 | UseCaseProvider | ~30 use case singletons |
| 6 | ViewModelProvider | AppRouter + all ViewModels (singleton/factory) |
| 7 | ServiceProvider | AppServices, PushNotificationService |

**Dual Backend Toggle:** `BackendConfig` reads `BACKEND` env var. If `"supabase"`, registers Supabase repos; otherwise REST API repos.

**Named Instances:** `UsersRepository` has two registrations: `DefaultUsersRepository` (local Floor cache) and `RemoteUsersRepository` (API/Supabase). `UserUseCase` takes both.

---

## HTTP Layer

`lib/src/api_calls_handler.dart`:

- Wraps `package:http` client
- Base URL: `https://api.bondly.mx/api/`
- Headers: `Content-type: application/json`, `Accept: application/json`, `Authorization: <token>`
- Methods: `get`, `post`, `put`, `delete`, `sendMultipart`
- Error mapping: 403 -> UnauthorizedException/ApiErrorException, 404 -> ServiceNotFoundException, 500+ -> ServerErrorException

---

## Authentication (JWT)

- **Token:** JWT encoded with `jwt-simple`, secret `TOKEN_SECRET`
- **Payload:** Entire user object + user `_id`
- **No expiration** - tokens are valid indefinitely
- **Middleware:** Decodes token, fetches fresh user from DB, sets `req.user`
- **Password:** bcrypt with 10 salt rounds
- **Client stores:** Raw token in SharedPreferences, injected as `Authorization` header

---

## Routing (All Routes)

| Route | Screen | Params |
|-------|--------|--------|
| `/` | StartScreen | - |
| `/login` | LoginScreen | - |
| `/forgot-password` | ForgotPasswordScreen | - |
| `/verify-reset-token` | VerifyResetTokenScreen | email (extras) |
| `/reset-password` | ResetPasswordScreen | token (extras) |
| `/reset-password-confirmation` | ResetPasswordConfirmationScreen | - |
| `/home` | HomeScreen | - |
| `/profile` | ProfileScreen | - |
| `/notifications` | NotificationsScreen | - |
| `/my-activity` | MyActivityScreen | - |
| `/my-rewards` | MyRewardsScreen | - |
| `/my-cart` | MyCartScreen | - |
| `/monthly-balance` | MonthlyBalanceScreen | - |
| `/my-badges` | MyBadgesScreen | - |
| `/ranking` | RankingScreen | - |
| `/my-data` | MyDataScreen | - |
| `/activity-detail` | ActivityDetailScreen | activityId, feedId, isRead (extras) |

---

## Local Storage

- **SharedPreferences:** Session token (`SESSION_TOKEN_KEY`), login state (`LoginState`), local cart items (`local_cart_items`)
- **Floor SQLite:** Single `UserEntity` table (mirrors User model), `bondly.db`, used as local cache

---

## Multi-Tenancy

Data is segregated by:
- `companyName` - String identifier for the company
- `accountNumber` / `accountHolder` - Numeric account reference (creators get a unique number, invitees reference the creator's)

---

## Theme & Styling

- **Colors:** `BondlyColorScheme` ThemeExtension with full light/dark palettes
- **Font:** Montserrat (via GoogleFonts)
- **Responsive:** `DeviceScale.dp` extension (reference height: 812 iPhone X)
- **Strings:** All Spanish, centralized in `lib/config/strings_*.dart`
- **Material 3:** Disabled (`useMaterial3: false`)

---

## Environment Variables (.env)

```
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
GEMINI_API_KEY=...
BACKEND=api|supabase
```
