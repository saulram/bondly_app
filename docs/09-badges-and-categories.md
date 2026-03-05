# Badges & Categories Feature

## Overview

Badges are the core recognition unit in Bondly. Each badge belongs to a category, has a point value, and an image. When sending a recognition, users select a category, then a badge within it. The "My Badges" section shows all badges a user has received, organized by category.

---

## Database Schemas (MongoDB)

### BadgeCategory (`models/BadgeCategory.js`)

| Field | Type | Description |
|-------|------|-------------|
| `name` | String | Category name (e.g., "Competencias", "Valores", "Especiales") |
| `account` | Number | Account number (multi-tenant key) |
| `type` | String | Category type |
| `description` | String | Category description |
| `imageUrl` | String | Category icon/image |
| `visible` | Boolean | Soft-delete flag |

### Badge (`models/Badge.js`)

| Field | Type | Description |
|-------|------|-------------|
| `category_id` | ObjectId ref BadgeCategory | Parent category |
| `name` | String | Badge name |
| `image` | String | Badge image path |
| `value` | Number | Point value (cost to send) |
| `expires` | Date | Expiration date |
| `isActive` | Boolean | Default true |
| `visible` | Boolean | Soft-delete flag |

---

## API Endpoints

### Categories

```
GET /api/badgeCategory/account
Auth: JWT
Response: { success: true, data: [BadgeCategory...] }
```
- Returns categories for the user's account number

```
GET /api/badgeCategory
Auth: JWT
```
- All visible categories

```
POST /api/badgeCategory (with multer for image)
GET /api/badgeCategory/:id
PUT /api/badgeCategory/:id (with multer)
DELETE /api/badgeCategory/:id (soft-delete)
```

### Badges

```
GET /api/badge/category/:categoryId
Auth: JWT
Response: { success: true, data: [Badge...] }
```
- Badges within a specific category

```
GET /api/badge
Auth: JWT
```
- All visible badges

```
GET /api/badge/mybadges
Auth: JWT
Response: {
  success: true,
  data: {
    embassys: { count, data: [Ambassador...] },
    myBadges: { count, data: [BadgeReport...] },
    categories: [BadgeCategory with populated badges...]
  }
}
```
- Comprehensive badge report for the current user:
  - `embassys`: Ambassador records for this user (populated with user and badge)
  - `myBadges`: BadgeReport records where user is receiver (populated)
  - `categories`: All badge categories with their badges populated

### Badge Reports

```
POST /api/badge/report
Auth: JWT
Body: { badge_id, startDate, endDate, format: "json"|"csv" }
Response: JSON report or CSV file download
```
- Report of all BadgeReport entries for a specific badge in date range

```
POST /api/badge/report/company
Auth: JWT
Body: { startDate, endDate, format: "json"|"csv" }
Response: Company-wide badge report (JSON or CSV)
```

### Chart Data

```
GET /api/badge/treemap
Auth: JWT
```
- Treemap chart data: badges grouped by category with counts

```
GET /api/badge/areaChart
Auth: JWT
```
- Area chart: total badges by company, aggregated daily

---

## Flutter Domain Models

### Categories
```dart
class Categories {
  List<Category> categories;
}
```

### Category
```dart
class Category {
  String id;
  String name;
  String account;
  String description;
  String imageUrl;
  String type;
  bool visible;
  List<Badge> categoryBadges;
}
```

### Badge
```dart
class Badge {
  String id;
  String categoryId;
  String name;
  String image;
  int value;
  bool isActive;
}
```

### Badges (CategoryBadges wrapper)
```dart
class Badges {
  List<Badge> badges;
}
```

### BondlyBadges (My Badges screen)
```dart
class BondlyBadges {
  Embassys embassys;       // { count, list of embassies }
  MyBadges myBadges;       // { count, list of received badges }
  List<BondlyCategory> categories;  // All categories with badges
}
```

### BondlyCategory
```dart
class BondlyCategory {
  String id;
  String name;
  String account;
  String description;
  String imageUrl;
  List<BondlyBadge> categoryBadges;
}
```

### BondlyBadge
```dart
class BondlyBadge {
  String id;
  String categoryId;
  String name;
  String image;
  int value;
  bool isActive;
  bool visible;
}
```

---

## Repository Interfaces

### CompanyFeedsRepository (badge methods)
```dart
Future<Result<Categories, Exception>> getCategories();
Future<Result<Badges, Exception>> getBadges(String categoryId);
```

### BondlyBadgesRepository
```dart
abstract class BondlyBadgesRepository {
  Future<Result<BondlyBadges, Exception>> getBondlyBadges();
}
```

---

## Use Cases

| Use Case | Description |
|----------|-------------|
| `GetCategoriesUseCase` | Gets badge categories for user's account |
| `GetCategoryBadgesUseCase` | Gets badges within a category |
| `GetBondlyBadgesUseCase` | Gets comprehensive badge report (embassys + myBadges + categories) |

---

## UI Screens

### Recognition Tab (HomeScreen Tab 2)
1. Display category cards (from `getCategories`)
2. User taps category -> loads badges for that category
3. User selects a badge -> shows point value
4. User @mentions recipients
5. User writes message
6. Submit creates acknowledgment

### MyBadgesScreen (`/my-badges`)
- Shows three sections:
  - **Embassys:** Ambassador badges earned
  - **My Badges:** All badges received via recognitions
  - **Categories:** All available categories with their badges
- Badge gradient colors by category type: Competencias (blue), Especiales (gold), Valores (purple)

---

## BondlyBadgesViewModel (Factory)

- `badges: BondlyBadges?` - Complete badge data
- `loadBadges()` - Fetches via `GetBondlyBadgesUseCase`

---

## Key Business Rules for Supabase Migration

1. **Categories are account-scoped** via `account` number field
2. **Badge value** determines point cost for recognitions - Critical for the points economy
3. **Badge images** need Supabase Storage migration
4. **BadgeReport** is a separate analytics table created on each acknowledgment - One per recipient per recognition
5. **mybadges endpoint** is a composite query returning 3 different data types
6. **Treemap and area chart** data need Supabase functions/views for aggregation
7. **CSV report generation** needs Supabase Edge Function
8. **Categories have types** used for UI color coding (Competencias, Especiales, Valores)
9. **Badges can expire** via `expires` date field
10. **Badge visibility** is independent of category visibility
