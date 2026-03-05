# Feed & Recognitions Feature

## Overview

The feed is the central social feature of Bondly. It displays a timeline of recognitions, exchanges, and company announcements. Users can create recognitions (acknowledgments) by selecting a badge and sending it to one or more colleagues, deducting points from the sender and adding them to recipients.

---

## Database Schemas (MongoDB)

### AccountFeed (`models/AccountFeed.js`)

| Field | Type | Description |
|-------|------|-------------|
| `account` | Number | Account number (multi-tenant key) |
| `header` | String | Feed header text |
| `body` | String | Feed body/message |
| `footer` | String | Feed footer text |
| `image` | String | Optional image path |
| `sender_id` | ObjectId ref User | Who created this feed entry |
| `isHighlited` | Boolean | Highlighted flag |
| `comments` | Array | `[{ user_id: ObjectId, message: String, timeStamp: Date }]` |
| `likes` | Array | `[{ user_id: ObjectId, timeStamp: Date }]` |
| `type` | Enum | `reconocimiento`, `canje`, `comentario`, `recompensa` |
| `badge_id` | ObjectId ref Badge | Optional, for recognition type |
| `visible` | Boolean | Soft-delete flag |
| `createdAt` | Date | Auto (timestamps) |
| `updatedAt` | Date | Auto (timestamps) |

### Acknowledgment (`models/Acknowledgments.js`)

| Field | Type | Description |
|-------|------|-------------|
| `badge_id` | ObjectId ref Badge | The badge being given |
| `user_id` | ObjectId ref User | Primary recipient (first in recipients array) |
| `recipients` | [ObjectId ref User] | All recipients |
| `sender_id` | ObjectId ref User | Who is giving the recognition |
| `message` | String | Recognition message |
| `hidden` | Boolean | Default false |
| `account` | Number | Account number |
| `visible` | Boolean | Soft-delete flag |
| `createdAt` | Date | Auto |
| `updatedAt` | Date | Auto |

### BadgeReport (`models/BadgeReport.model.js`)

| Field | Type | Description |
|-------|------|-------------|
| `category_id` | ObjectId ref BadgeCategory | |
| `badge_id` | ObjectId ref Badge | |
| `sender_profile_id` | ObjectId ref UserProfile | |
| `receiver_profile_id` | ObjectId ref UserProfile | |
| `sender_id` | ObjectId ref User | |
| `receiver_id` | ObjectId ref User | |
| `createdAt` | Date | Auto |
| `updatedAt` | Date | Auto |

---

## API Endpoints

### Feed Endpoints

```
GET /api/accountFeeds/feeds
Auth: JWT
Response: { success: true, count: N, data: [FeedData...] }
```
- Fetches all feeds for user's account (by `account` number)
- Populates `sender_id` (full user object) and `badge_id`
- Adds `userLike: boolean` flag per feed (whether current user liked it)
- Sorted by `createdAt` descending

```
GET /api/accountFeeds/feeds/:id
Auth: JWT
Response: { success: true, data: FeedData }
```

```
POST /api/accountFeeds/feeds
Auth: JWT
Body: { header, body, footer, image, type, badge_id }
Response: { success: true, data: FeedData }
```

```
PUT /api/accountFeeds/feeds/:id
Auth: JWT
Body: { fields to update }
```

```
DELETE /api/accountFeeds/feeds/:id
Auth: JWT
```
- Soft-delete: sets `visible: false`

### Comment Endpoints

```
POST /api/accountFeeds/feeds/:id/comments
Auth: JWT
Body: { message }
Response: { success: true, data: updated FeedData }
```
- Pushes `{ user_id: req.user._id, message, timeStamp: Date.now() }` to feed's comments array

```
DELETE /api/accountFeeds/feeds/:id/comments/:commentId
Auth: JWT
```
- Pulls comment from array by commentId

### Like Endpoint

```
POST /api/accountFeeds/feeds/:id/likes
Auth: JWT
Response: { success: true, data: updated FeedData }
```
- **Toggle behavior:** If user already liked, removes the like; otherwise adds it
- Implementation: Checks if `likes` array contains a like with `user_id` matching current user

### Chart Data

```
GET /api/accountFeeds/chart
Auth: JWT
Response: { success: true, data: { currentMonth: [...], lastMonth: [...] } }
```
- Returns feed counts per day for current and previous month (line chart data)

### Acknowledgment Endpoints

```
POST /api/acknowledgments
Auth: JWT
Body: { badge_id, message, recipients: [userId, userId, ...] }
Response: { success: true, data: Acknowledgment }
```
**This is the core recognition flow. Business logic in `acknowledgment.Service.js`:**

1. Validates sender hasn't recognized `recipients[0]` for the same badge in the current calendar month
2. Looks up badge to get its `value` (point cost)
3. Calculates `totalPoints = badge.value * recipients.length`
4. Checks sender has enough `giftedPoints >= totalPoints`
5. Deducts from sender: `giftedPoints -= totalPoints`
6. Adds to each recipient: `pointsReceived += badge.value`
7. Creates Acknowledgment document
8. Creates AccountFeed entry (type: `reconocimiento`) with:
   - `header`: "Ha enviado un reconocimiento"
   - `body`: the message
   - `sender_id`: sender
   - `badge_id`: the badge
   - `account`: sender's accountNumber or accountHolder
9. Creates Activity for each recipient: title = "Has recibido un reconocimiento", links to feed
10. Creates BadgeReport for each recipient (analytics/reporting)

```
GET /api/acknowledgments
Auth: JWT
Response: { success: true, data: [Acknowledgment...] }
```
- Filtered by user's account number

```
GET /api/acknowledgments/:id
PUT /api/acknowledgments/:id
DELETE /api/acknowledgments/:id  (soft-delete)
```

---

## Flutter Domain Models

### CompanyFeed
```dart
class CompanyFeed {
  bool success;
  List<FeedData> data;
}
```

### FeedData
```dart
class FeedData {
  String id;
  String account;
  String header;
  String body;
  String footer;
  Sender sender;
  String type;
  Badge? badge;
  List<Comment> comments;
  List<Like> likes;
  String createdAt;
  String updatedAt;
  bool visible;
  bool isLiked;     // computed from likes array on client
  String? image;
}
```

### Sender (embedded in FeedData)
```dart
class Sender {
  String id;
  String completeName;
  int employeeNumber;
  String role;
  String email;
  String avatar;
  String companyName;
  int monthlyPoints;
  int giftedPoints;
  int pointsReceived;
  bool visible;
  // ... other user fields
}
```

### Comment
```dart
class Comment {
  Sender user;
  String message;
  String timeStamp;
  String id;
}
```

### Like
```dart
class Like {
  String id;
}
```

---

## Repository Interface

### CompanyFeedsRepository
```dart
abstract class CompanyFeedsRepository {
  Future<Result<CompanyFeed, Exception>> getCompanyFeeds();
  Future<Result<FeedData, Exception>> getCompanyFeedById(String feedId);
  Future<Result<FeedData, Exception>> createComment(String feedId, String message);
  Future<Result<bool, Exception>> likePost(String feedId);
  Future<Result<Categories, Exception>> getCategories();
  Future<Result<Badges, Exception>> getBadges(String categoryId);
  Future<Result<List<User>, Exception>> getCompanyCollaborators();
  Future<Result<bool, Exception>> createAcknowledgment(String badgeId, String message, List<String> recipients);
  Future<Result<Announcements, Exception>> getCompanyAnnouncements();
  Future<Result<List<Embassy>, Exception>> getUserEmbassys(String userId);
}
```

---

## Use Cases

| Use Case | Description |
|----------|-------------|
| `GetCompanyFeedsUseCase` | Fetches all feeds for the company |
| `CreateFeedCommentUseCase` | Adds a comment to a feed post |
| `HandleLikesUseCase` | Toggles like on a feed post |
| `GetCategoriesUseCase` | Gets badge categories for the account |
| `GetCategoryBadgesUseCase` | Gets badges within a category |
| `GetCompanyCollaboratorsUseCase` | Gets list of company users (for @mentions) |
| `CreateAcknowledgmentUseCase` | Creates a recognition (the core business action) |
| `GetCompanyAnnouncementsUseCase` | Fetches company news/announcements |
| `GetUserEmbassysUseCase` | Gets user's ambassador/embassy badges |

---

## UI Screens & Flow

### HomeScreen (`/home`) - 3-Tab PageView

**Tab 0: Ambassadors/Embassy Tab**
- Shows user's embassy badges (ambassador achievements)
- Fetches via `GetUserEmbassysUseCase`

**Tab 1: Feed Tab (Default)**
- Shows all company feed posts (newest first)
- Each post shows: sender avatar, sender name, badge image, message, timestamp
- Like button (toggles)
- Comment section (expandable)
- Optional AI personalization toggle (reorders by relevance via Gemini)
- Optional sentiment badges per post

**Tab 2: Recognize Tab**
- Step 1: Select a badge category -> loads categories from API
- Step 2: Select a specific badge -> loads badges for that category
- Step 3: @mention recipients from collaborators list (uses `flutter_mentions`)
- Step 4: Write a recognition message
- Step 5: Submit -> `CreateAcknowledgmentUseCase` -> refresh feed

### Post Detail (via Activity Detail)
- Accessed from activity screen, shows single feed post with comments

---

## HomeViewModel (Singleton)

**Initialization (`setUp()`):**
1. Load user from local DB
2. Parallel calls: banners, feeds, embassys, categories, collaborators, announcements, ranking (top 3)

**Key state:**
- `feeds: List<FeedData>` - All feed items
- `personalizedFeeds: List<FeedData>` - AI-reordered feeds
- `isPersonalized: bool` - AI toggle state
- `sentimentCache: Map<String, SentimentResult>` - Cached sentiment per feed
- `categories: List<Category>` - Badge categories
- `selectedCategory: Category?` - Currently selected category
- `selectedBadge: Badge?` - Currently selected badge
- `mentionedUsers: List<User>` - Selected recipients
- `collaborators: List<User>` - All company users

**Key methods:**
- `loadFeeds()` - Refreshes feed from API
- `handleLike(feedId)` - Toggles like, refreshes feed
- `createComment(feedId, message)` - Adds comment, refreshes feed
- `selectCategory(category)` - Sets selected category, loads its badges
- `createAcknowledgment(message)` - Submits recognition with selected badge and recipients

---

## Key Business Rules for Supabase Migration

1. **One recognition per recipient per month per badge** - Sender cannot recognize the same primary recipient for the same badge twice in one calendar month
2. **Points deduction is multiplicative** - `totalPoints = badge.value * recipients.length`
3. **Feed entries are created as side effects** - Acknowledgments, exchanges, and new rewards all create feed entries
4. **Activities are created as side effects** - One activity per recipient when receiving a recognition
5. **BadgeReports are created as side effects** - One report per recipient (for analytics)
6. **Like is a toggle** - Same endpoint to like and unlike
7. **Comments include user_id and timestamp** - Embedded in feed document (not separate collection)
8. **Feed is scoped by account number** - Uses `accountNumber` or `accountHolder` for multi-tenant filtering
9. **Feed types:** `reconocimiento` (recognition), `canje` (exchange/redemption), `comentario` (comment), `recompensa` (new reward added)
