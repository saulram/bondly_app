# Authentication Feature

## Overview

Handles user login, logout, password reset flow, session persistence, and company selection. Users authenticate with employee number + password + company name.

---

## Database Schema (MongoDB)

### User Model (`models/Users.js`)

| Field | Type | Description |
|-------|------|-------------|
| `completeName` | String | Full name |
| `employeeNumber` | Number | Unique employee identifier |
| `avatar` | String | File path to avatar image |
| `password` | String | bcrypt hashed (10 rounds, pre-save hook) |
| `role` | Enum | `superAdmin`, `admin`, `client` |
| `createdAt` | Date | Account creation date |
| `accountNumber` | Number | 8-digit random (for creators) |
| `accountHolder` | Number | Reference to creator's accountNumber (for invitees) |
| `email` | String | Unique email |
| `isActive` | Boolean | Default true |
| `seats` | Number | Max invitees allowed (for creators) |
| `planType` | Enum | `free`, `premium`, `standard`, `enterprise`, `Basic`, `plus` |
| `monthlyPoints` | Number | Budget allocated per month |
| `accountType` | Enum | `creator`, `invitee` |
| `companyName` | String | Company identifier |
| `pointsReceived` | Number | Points received from recognitions (spendable) |
| `giftedPoints` | Number | Points available to give via recognitions |
| `rewards` | [ObjectId] | Ref to Reward documents |
| `visible` | Boolean | Soft-delete flag (default true) |

**Methods:**
- `matchPassword(enteredPassword)` - bcrypt compare

**Pre-save hook:** If password is modified, bcrypt hash with 10 salt rounds.

---

## API Endpoints

### Login
```
POST /api/users/login
Auth: None
Body: { employeeNumber, password, companyName }
Response: { success: true, data: { user object with token } }
```
- Finds user by `employeeNumber` + `companyName`
- Compares password via bcrypt
- Generates JWT: `jwt.encode({ user, id: user._id }, TOKEN_SECRET)`
- Returns full user object with token

### Login by Email (alternative)
```
POST /api/users/loginEmail
Auth: None
Body: { email, password }
Response: { success: true, data: { user object with token } }
```

### Get Companies
```
GET /api/users/companies
Auth: None
Response: { success: true, data: ["CompanyA", "CompanyB", ...] }
```
- Returns `distinct('companyName')` from Users collection

### Create User
```
POST /api/users
Auth: None
Body: { completeName, employeeNumber, password, email, companyName, role, accountType, planType, monthlyPoints, seats, ... }
Response: { success: true, data: { user }, message }
```
- For `creator`: generates random 8-digit `accountNumber`, creates cart, creates user profile
- For `invitee`: sets `accountHolder` to creator's `accountNumber`, `giftedPoints = monthlyPoints`, `pointsReceived = 350`, creates cart, creates user profile

### Get User Profile (Authenticated)
```
GET /api/users/profile
Auth: JWT
Response: { user object }
```

### Password Reset Flow

**Step 1: Request Reset**
```
POST /api/users/reset-password
Auth: None
Body: { email }
```
- Note: No email service exists in backend - this endpoint may be incomplete or handled externally

**Step 2: Verify Token**
```
POST /api/users/verify-reset-token
Auth: None
Body: { token }
```

**Step 3: Confirm New Password**
```
POST /api/users/confirm-reset-password
Auth: None
Body: { token, password }
```

---

## Flutter Domain Model

### User (`lib/features/auth/domain/models/user_model.dart`)

```dart
class User {
  String id;
  String completeName;
  int employeeNumber;
  String role;
  int accountNumber;
  int accountHolder;
  String email;
  bool isActive;
  int seats;
  String planType;
  int monthlyPoints;
  String accountType;
  String companyName;
  String avatar;
  int giftedPoints;
  int pointsReceived;
  bool isVisible;
  String token;
  List<dynamic> rewards;
}
```

**Factory constructors:**
- `fromJson(Map)` - Expects `data` key wrapper
- `fromSingleJson(Map)` - Flat JSON
- `fromSupabaseAuth(Map)` - From Supabase auth response
- `fromSupabase(Map)` - From Supabase DB query

---

## Repository Interface

### AuthRepository
```dart
abstract class AuthRepository {
  Future<Result<User, Exception>> doLogin(String user, String password, String company);
  Future<Result<List<String>, Exception>> getCompanies();
  Future<Result<bool, Exception>> resetPassword(String email);
  Future<Result<bool, Exception>> verifyResetToken(String token);
  Future<Result<bool, Exception>> confirmResetPassword(String token, String newPassword);
}
```

### UsersRepository
```dart
abstract class UsersRepository {
  Future<Result<User, Exception>> getUser();
  Future<void> insertUser(User user);
  Future<void> updateAvatar(Map<String, dynamic> params);
  Future<Result<UserProfile, Exception>> getFullProfile(String userId);
  Future<void> updateProfile(Map<String, dynamic> data);
  Future<void> clear();
}
```

### SessionTokenHandler
```dart
abstract class SessionTokenHandler {
  Future<void> save(String token);
  Future<String?> get();
  Future<void> clear();
}
```

---

## Use Cases

| Use Case | Logic |
|----------|-------|
| `LoginUseCase` | Validates company is selected and fields non-empty, calls `authRepository.doLogin()` |
| `LogoutUseCase` | Clears SharedPreferences and local UsersRepository (Floor DB) |
| `GetLoginStateUseCase` | Reads/writes boolean `LoginState` from SharedPreferences |
| `GetCompaniesUseCase` | Passthrough to `authRepository.getCompanies()` |
| `UserUseCase` | Gets user from local (Floor) or remote repo based on `remote` flag; updates local on remote fetch |
| `ForgotPasswordUseCase` | Validates email regex, calls `authRepository.resetPassword()` |
| `VerifyResetTokenUseCase` | Validates token length >= 6, calls `authRepository.verifyResetToken()` |
| `ResetPasswordUseCase` | Validates password length >= 8 and match, calls `authRepository.confirmResetPassword()` |

---

## UI Screens & Flow

### Login Flow
1. **StartScreen** (`/`) - Splash, checks `LoginState` in SharedPreferences
2. After 1.5s delay, navigates to `/login` or `/home`
3. **LoginScreen** (`/login`) - Loads companies list dropdown, user enters employeeNumber + password
4. On submit: POST login -> save token to SharedPreferences + save user to Floor DB -> navigate to `/home`

### Password Reset Flow
1. **ForgotPasswordScreen** (`/forgot-password`) - Enter email -> POST reset-password
2. **VerifyResetTokenScreen** (`/verify-reset-token`) - Enter 6-digit code -> POST verify
3. **ResetPasswordScreen** (`/reset-password`) - Enter new password + confirm -> POST confirm
4. **ResetPasswordConfirmationScreen** (`/reset-password-confirmation`) - Success message

### Logout
- Clears SharedPreferences (token + login state) + Floor DB (local user cache)
- Navigates to `/login`

---

## ViewModels

### LoginViewModel
- `setUp()`: Loads companies list via `GetCompaniesUseCase`
- `doLogin(employeeNumber, password, company)`: Calls `LoginUseCase`, saves token, saves login state, caches user locally, navigates to `/home`
- States: `LoadingLogin`, `SuccessLogin`, `FailedLogin(LoginErrorType)`, `SuccessCompaniesLoad`, `FailedCompaniesLoad`

### ForgotPasswordViewModel, VerifyResetTokenViewModel, ResetPasswordViewModel
- Each manages their respective form state and API calls

---

## Key Business Rules for Supabase Migration

1. **JWT has no expiration** - Consider adding token expiration in Supabase
2. **Password hashing** is bcrypt with 10 rounds - Supabase Auth handles this natively
3. **User creation** auto-creates a Cart and UserProfile - Need triggers or functions in Supabase
4. **New invitees** start with `pointsReceived = 350` and `giftedPoints = monthlyPoints`
5. **Company selection** at login - Multi-tenant via `companyName` field
6. **No role-based authorization** in current backend - All JWT-protected routes accessible to any authenticated user
7. **Token stored as raw string** in SharedPreferences (no "Bearer " prefix on client side)
8. **No email service** exists - Password reset may need Supabase Auth email templates
