# Activity Tracking Feature

## Overview

Activities are auto-generated notification records that track events relevant to a user: receiving recognitions, getting likes, earning ambassadorships, and redeeming rewards. Each activity links to a feed post for navigation.

---

## Database Schema (MongoDB)

### Activity (`models/Activity.js`)

| Field | Type | Description |
|-------|------|-------------|
| `user_id` | ObjectId ref User | Who this activity is for |
| `title` | String | Activity title/description |
| `content` | String | Activity content/detail |
| `read` | Boolean | Read status (default false) |
| `companyName` | String | Company scope |
| `feed_id` | ObjectId ref AccountFeed | Linked feed post |
| `createdAt` | Date | Auto |
| `updatedAt` | Date | Auto |

---

## Activity Types (title -> display label)

| Title (stored) | Display Label | Created By |
|----------------|---------------|------------|
| `Has canjeado una recompensa` | Recompensas | Cart checkout |
| `Has recibido un "me gusta" en un post relacionado contigo` | Me Gusta | Like on related post |
| `Has recibido una embajada` | Embajadas | Ambassador calculation |
| `Has recibido un reconocimiento` | Reconocimientos | Acknowledgment creation |
| `Han comentado un post relacionado contigo` | Comentario nuevo | Comment on related post |

---

## API Endpoints

```
GET /api/activity?user_id=X&limit=N&page=P
Auth: JWT
Response: { success: true, count: N, pagination: { next, prev }, data: [Activity...] }
```
- Uses `advancedResults` middleware for pagination
- Default limit: 1000 (overridden to 10 on client)
- Activity `title` is mapped to display labels in the controller
- Sorted by createdAt descending

```
GET /api/activity/my
Auth: JWT
Response: Activities for authenticated user
```

```
GET /api/activity/:id
Auth: JWT
```

```
POST /api/activity
Auth: JWT
Body: { user_id, title, content, companyName, feed_id }
```
- Usually created as side effects (not directly by users)

```
PUT /api/activity/:id
Auth: JWT
Body: { read: true, ... }
```
- Used to mark activities as read

```
DELETE /api/activity/:id
Auth: JWT
```

---

## Flutter Domain Models

### UserActivityHolder
```dart
class UserActivityHolder {
  int count;
  String? nextPage;
  String? prevPage;
  List<UserActivityItem> activity;
}
```

### UserActivityItem
```dart
class UserActivityItem {
  String id;
  String userId;
  String? feedId;
  String title;
  String content;
  bool read;
  String createdAt;
  String updatedAt;
  String? type;  // Mapped display label
}
```

---

## Repository Interface

### ActivityRepository
```dart
abstract class ActivityRepository {
  Future<Result<UserActivityHolder, Exception>> getActivityList(String userId, int limit, int page);
  Future<Result<bool, Exception>> updateActivityStatus(String activityId);
}
```

---

## Use Cases

| Use Case | Description |
|----------|-------------|
| `GetUserActivityUseCase` | Paginated activity list; also `invokeSingle(feedId)` for single feed detail |
| `UpdateUserActivityUseCase` | Marks activity as read (`PUT activity/:id` with `read: true`) |

**Note:** `GetUserActivityUseCase` also has an `invokeSingle(feedId)` method that calls `companyFeedsRepository.getCompanyFeedById(feedId)` to get the associated feed post detail.

---

## UI Screens & Flow

### MyActivityScreen (`/my-activity`)
- Gets user ID from local DB
- Loads activities paginated (limit=10, page increments on scroll)
- Each item shows: type icon, title (mapped label), content, timestamp, read/unread indicator
- Tap on item navigates to ActivityDetailScreen

### ActivityDetailScreen (`/activity-detail`)
- Receives: `activityId`, `feedId`, `isRead` via route extras
- Loads single feed detail via `getCompanyFeedById(feedId)`
- Marks activity as read via `updateActivityStatus(activityId)` if not already read
- Shows full feed post: sender, badge, message, comments, likes

---

## ViewModels

### MyActivityViewModel (Factory)
- `activities: List<UserActivityItem>` - Loaded activities
- `currentPage: int` - Pagination state
- `loadActivities()` - Fetches next page
- Infinite scroll support

### ActivityDetailViewModel (Factory)
- `feedData: FeedData?` - The associated feed post
- `loadDetail(feedId)` - Fetches single feed
- `markAsRead(activityId)` - Updates read status

---

## Key Business Rules for Supabase Migration

1. **Activities are auto-created** as side effects of:
   - Acknowledgment creation (one per recipient)
   - Cart checkout (one per reward exchanged)
   - Ambassador calculation (one per new ambassador)
   - Comments and likes on related posts
2. **Activities link to feed posts** via `feed_id` - Navigation depends on this
3. **Read status** is boolean, updated independently
4. **Pagination** uses page/limit with advancedResults middleware
5. **Type mapping** happens in the controller (title string -> display label) - This should be a computed field or enum in Supabase
6. **Company scoping** via `companyName` field
7. **No push notifications** - Activities serve as the primary in-app notification system
