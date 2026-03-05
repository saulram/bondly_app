# Profile Management Feature

## Overview

Users can view and edit their profile information (name, email, job position, location, date of birth), upload avatar images, and access various sub-sections (activity, rewards, badges, balance).

---

## Database Schemas (MongoDB)

### UserProfile (`models/UserProfile.js`)

| Field | Type | Description |
|-------|------|-------------|
| `user_id` | ObjectId ref User | Link to User document |
| `jobPosition` | String | Job title |
| `location` | String | Office/city location |
| `jobArea` | String | Department/area |
| `isAmbassador` | Boolean | Ambassador status |
| `ambassadorTitle` | String | Ambassador title |
| `bDay` | Date | Birthday |
| `companyName` | String | Company scope |
| `visible` | Boolean | Soft-delete flag |

**Note:** UserProfile is auto-created when a user is registered. Soft-deleted when user is deleted.

### User Model (avatar-related)
- `avatar` field stores the file path (e.g., `public/upload/1234567890.jpg`)
- Uploaded via multer middleware

---

## API Endpoints

### Get Full Profile
```
GET /api/userProfile/user/:userId
Auth: JWT
Response: { success: true, data: UserProfile (populated with user) }
```

### Update Profile
```
PUT /api/userProfile/:profileId
Auth: JWT
Body: { jobPosition?, location?, jobArea?, bDay?, email? }
Response: { success: true, data: updated UserProfile }
```

### Get Company Profiles
```
GET /api/userProfile/company
Auth: JWT
Response: { success: true, data: [UserProfile...] }
```
- Filtered by user's companyName

### Upload Avatar
```
PUT /api/users/uploadAvatar/:userId
Auth: JWT + multer
Body: multipart form with image file
Response: { success: true, data: updated User }
```
- Stores file at `public/upload/{timestamp}.{ext}`
- Updates `avatar` field on User document

### Get User (authenticated)
```
GET /api/users/profile
Auth: JWT
Response: { user object }
```

### Update User
```
PUT /api/users/:id
Auth: JWT
Body: { fields to update }
```

---

## Flutter Domain Models

### UserProfile
```dart
class UserProfile {
  User user;
  String companyName;
  String jobPosition;
  String location;
  DateTime dob;
  String id;
}
```

---

## Repository Interface

### UsersRepository (shared with auth)
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

---

## Use Cases

| Use Case | Description |
|----------|-------------|
| `UserUseCase` | Gets user from local or remote repo; `remote` flag to force API call |
| `UserProfileUseCase` | Gets/updates full profile (job, location, dob, email) |
| `UpdateUserAvatarUseCase` | Uploads new avatar image via multipart |

---

## UI Screens & Flow

### ProfileScreen (`/profile`)
- Loads user data (local first, then remote refresh)
- Displays: avatar, name, employee number, company
- Shows spendable balance (pointsReceived)
- Menu options navigate to sub-sections:
  - My Data -> `/my-data`
  - My Activity -> `/my-activity`
  - My Rewards -> `/my-rewards`
  - My Cart -> `/my-cart`
  - Monthly Balance -> `/monthly-balance`
  - My Badges -> `/my-badges`
  - Ranking -> `/ranking`
  - Logout

### MyDataScreen (`/my-data`)
- Form fields: email, job position, location, date of birth
- Pre-populated from `getFullProfile()`
- Save button calls `updateProfile()`
- Avatar tap opens image picker -> `updateAvatar()`

---

## ProfileViewModel (Factory)

**Key state:**
- `user: User?` - Current user data
- `userProfile: UserProfile?` - Extended profile data
- `spendableBalance: int` - Points available to spend

**Key methods:**
- `loadUser()` - Fetches user from remote, updates local cache
- `logout()` - Calls `LogoutUseCase`, navigates to `/login`
- `updateAvatar(imagePath)` - Picks image, uploads via multipart
- `saveProfileData(email, jobPosition, location, dob)` - Updates profile via API
- `fetchSpendableBalance()` - Gets account statement balance

---

## Key Business Rules for Supabase Migration

1. **UserProfile is a separate document/table** from User - linked by `user_id`
2. **Auto-created on user registration** - Must have trigger or function in Supabase
3. **Avatar upload** is multipart file upload stored on disk - Need Supabase Storage
4. **Avatar URL** is `https://api.bondly.mx/{path}` - Will change to Supabase Storage URL
5. **Soft-delete cascade** - Deleting user also soft-deletes their profile
6. **Local user cache** via Floor DB - UserUseCase tries local first, then remote
7. **Profile fields** (jobPosition, location, bDay) are separate from auth fields (email, password)
