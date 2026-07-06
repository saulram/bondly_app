# Rankings & Ambassadors Feature

## Overview

The ambassador system recognizes top performers monthly. A cron job runs on the 1st of each month, analyzing the previous month's acknowledgments to determine who received the most recognitions per badge. Rankings show leaderboards by period (month/quarter/year).

---

## Database Schema (MongoDB)

### Ambassador (`models/Ambassador.js`)

| Field | Type | Description |
|-------|------|-------------|
| `user_id` | ObjectId ref User | The ambassador |
| `badge_id` | ObjectId ref Badge | The badge they're ambassador for |
| `date` | Date | When the ambassadorship was earned |
| `visible` | Boolean | Soft-delete flag |

---

## Ambassador Calculation Logic

**File:** `controllers/ambassador.js` (cron job + manual trigger)

**Schedule:** `0 0 1 * *` (midnight on the 1st of every month)

**Algorithm:**
1. Get all acknowledgments from the previous calendar month
2. Group acknowledgments by `badge_id`
3. For each badge:
   a. Count how many times each user received that badge (as recipient)
   b. Find the user with the highest count
   c. **Only create an ambassador if there's a single winner** (no ties)
4. For each new ambassador:
   a. Create Ambassador document
   b. Create AccountFeed entry (header: "Ha sido nombrado embajador")
   c. Create Activity for the user ("Has recibido una embajada")

**Important:** The ambassador is determined by **most received** badges (not given). It rewards the most recognized person for each badge category.

---

## API Endpoints

### Ambassador Endpoints

```
GET /api/ambassador
Auth: JWT
Response: { success: true, data: [Ambassador...] }
```
- All ambassadors

```
GET /api/ambassador/user/:userId
Auth: JWT
Response: { success: true, data: [Ambassador...] }
```
- Returns unique badges a user holds ambassador status for
- V2 variant returns badges with quantity (how many times earned)

```
GET /api/ambassador/badge/:badgeId
Auth: JWT
Response: { success: true, data: [Ambassador...] }
```

```
GET /api/ambassador/cron
Auth: JWT
```
- Manually triggers ambassador calculation

```
POST /api/ambassador
PUT /api/ambassador/:id
DELETE /api/ambassador/:id (soft-delete)
```

---

## Flutter Domain Models

### Embassy
```dart
class Embassy {
  String id;
  User userId;    // Populated user object
  Badge badgeId;  // Populated badge object
  String date;
}
```

### Embassys (collection wrapper)
```dart
class Embassys {
  List<Embassy> embassy;
}
```

### RankedUser (Ranking feature - Supabase only)
```dart
class RankedUser {
  int position;
  String name;
  String? avatarUrl;
  String? department;
  int recognitionCount;
}
```

---

## Repository Interfaces

### CompanyFeedsRepository (embassy method)
```dart
Future<Result<List<Embassy>, Exception>> getUserEmbassys(String userId);
```

### RankingRepository (Supabase-only)
```dart
abstract class RankingRepository {
  Future<Result<List<RankedUser>, Exception>> getRanking({
    required String period,  // 'month', 'quarter', 'year'
    int limit = 10,
  });
}
```

**Note:** Ranking is ONLY available with Supabase backend. The `SupabaseRankingRepository` is the only implementation.

---

## Use Cases

| Use Case | Description |
|----------|-------------|
| `GetUserEmbassysUseCase` | Gets user's ambassador/embassy badges |
| `GetRankingUseCase` | Gets ranked users by period (Supabase only) |

---

## UI Screens & Flow

### Ambassadors Tab (HomeScreen Tab 0)
- Shows user's embassy badges
- Each embassy shows: badge image, badge name, date earned
- Fetched via `GetUserEmbassysUseCase`

### HomeScreen Top 3
- The home ViewModel fetches top 3 ranking (from Supabase) for the podium display
- Shows 1st, 2nd, 3rd place with avatar and recognition count

### RankingScreen (`/ranking`)
- **Only available when using Supabase backend** (`isRankingEnabled => !BackendConfig.isApi`)
- Period selector: Month, Quarter, Year
- Top 3 podium display (1st center elevated, 2nd left, 3rd right)
- Below podium: scrollable list of positions 4-10
- Each entry: position, avatar, name, department, recognition count

---

## ViewModels

### RankingViewModel (Factory)
- `rankedUsers: List<RankedUser>` - Current ranking
- `selectedPeriod: String` - 'month', 'quarter', 'year'
- `loadRanking()` - Fetches ranking for selected period
- `changePeriod(period)` - Updates period and reloads

---

## Key Business Rules for Supabase Migration

1. **Ambassador calculation is a monthly cron job** - Needs to be a Supabase Edge Function or pg_cron
2. **No ties allowed** - If two users have equal counts for a badge, no ambassador is assigned
3. **Ambassador is per-badge** - A user can be ambassador for multiple badges
4. **Ambassadors accumulate** - Previous ambassadorships are preserved (not replaced)
5. **Side effects on creation:** Feed entry + Activity notification for the ambassador
6. **Ranking is currently Supabase-only** - Needs to query acknowledgment/recognition data
7. **Ranking periods:** Month (current calendar month), Quarter (current quarter), Year (current year)
8. **Ranking metric:** Total recognition count (number of acknowledgments received)
9. **Embassy display** on home screen uses populated User and Badge objects
10. **Manual trigger** available via `GET /api/ambassador/cron` for testing
