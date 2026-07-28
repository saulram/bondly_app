# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bondly is an HR rewards/recognition mobile app ("App de recompensas para Recursos Humanos") built with Flutter. It targets Android, iOS, and web. The backend is a REST API at `https://api.bondly.mx/api/`.

## Build & Development Commands

```bash
# Run the app
flutter run

# Build
flutter build apk          # Android
flutter build ios           # iOS

# Code generation (Floor database)
flutter packages pub run build_runner build

# Analyze
flutter analyze

# Tests
flutter test
```

**Dart SDK constraint:** `>=3.5.0 <4.0.0`

## Architecture

The app follows **Clean Architecture** with feature-based modules. Each feature under `lib/features/` has three layers:

```
features/<feature>/
├── domain/
│   ├── models/        # Pure Dart domain models (manual fromJson/toJson, no codegen)
│   ├── repositories/  # Abstract repository interfaces
│   └── usecases/      # Single-purpose use cases with invoke() method
├── data/
│   ├── repositories/  # Concrete implementations + api/ subdirectory for HTTP clients
│   ├── handlers/      # Concrete handler implementations
│   └── mappers/       # Data-to-domain mapping
└── ui/
    ├── screens/       # Screen widgets
    ├── viewmodels/    # ChangeNotifier-based ViewModels
    ├── widgets/       # Feature-scoped widgets
    └── states/        # Sealed UI state classes
```

**Features:** `auth`, `home`, `profile`, `start`, `storage` (local DB), `base` (shared ViewModel base classes), `main` (app-level model).

### State Management

Custom ViewModel layer built on `ChangeNotifier` + `provider`:

- **`DebouncedChangeNotifier`** — coalesces `notifyListeners()` calls via microtask scheduling
- **`ContextModel`** extends it with `BuildContext` awareness
- **`NavigationModel`** extends it with `GoRouter` navigation and a `busy` flag

Screens use `ModelProvider<T>` (injects model, sets context) wrapping `ModelBuilder<T>` (Consumer that rebuilds on notify).

Use cases return `Result<T, Exception>` from the `multiple_result` package, consumed via `result.when((success) {}, (error) {})`.

UI states use sealed classes (e.g., `LoginUIState` with `LoadingLogin`, `SuccessLogin`, `FailedLogin` subtypes).

### Dependency Injection

Uses `get_it` as a service locator. All wiring happens in `lib/dependencies/dependency_manager.dart`, which calls providers in order:

1. `StorageObjectsProvider` — SharedPreferences, Floor database, DAOs
2. `HandlersProvider` — SessionTokenHandler, ApiCallsHandler
3. `APIProvider` — All HTTP API client classes
4. `RepositoryProvider` — Abstract → concrete repository bindings
5. `UseCaseProvider` — Use case singletons (some with `dependsOn` for async init ordering)
6. `ViewModelProvider` — ViewModels + AppRouter (mix of singleton and factory registrations)
7. `ServiceProvider` — AppServices

**Important pattern:** Some repositories have multiple implementations registered with named instances (e.g., `DefaultUsersRepository` for local cache via Floor, `RemoteUsersRepository` for API). `UserUseCase` takes both and chooses based on a `remote` flag.

### Routing

`go_router` with routes defined in `lib/src/routes.dart`. `AppRouter` is a GetIt singleton. Navigation starts at `/` (StartScreen/splash), then redirects to login or home based on persisted session state in SharedPreferences.

### HTTP Layer

`lib/src/api_calls_handler.dart` wraps `package:http` — handles auth header injection (Bearer token from SharedPreferences), logging, error mapping, and multipart uploads. Each feature's API class defines its endpoints and delegates to this handler.

### Local Storage

- **SharedPreferences** — session token, login state
- **Floor** (SQLite ORM) — local user cache (`AppDatabase` in `lib/features/storage/`). Generated code at `bondly_database.g.dart`

## Key Conventions

- Domain models use manual `fromJson` factory constructors and `toJson` methods — no freezed or json_serializable
- One use case per class, with a single `invoke()` method
- API base URL hardcoded in `lib/config/environment.dart` (no flavor/environment switching)
- Assets referenced via generated constants in `lib/generated/assets.dart`
- App uses Montserrat font (bundled in `fonts/`) and Poppins (via google_fonts)
- Colors and theme defined in `lib/config/` (`bondly_colors.dart`, `bondly_theme.dart`)
- UI strings centralized in `lib/config/strings_main.dart`
