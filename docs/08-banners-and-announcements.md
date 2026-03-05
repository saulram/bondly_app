# Banners & Announcements Feature

## Overview

Company banners are promotional images displayed in carousels on the home screen. Announcements (news) are company-wide text notifications. Both are scoped by company.

---

## Database Schemas (MongoDB)

### Banner (`models/Banner.js`)

| Field | Type | Description |
|-------|------|-------------|
| `name` | String | Required, banner name |
| `slug` | String | URL-friendly identifier |
| `image` | String | File path to banner image |
| `description` | String | Banner description |
| `isActive` | Boolean | Default true |
| `companyName` | String | Company scope |
| `visible` | Boolean | Soft-delete flag |

### News (`models/News.js`)

| Field | Type | Description |
|-------|------|-------------|
| `title` | String | Announcement title |
| `content` | String | Announcement content |
| `image` | String | Optional image |
| `hidden` | Boolean | Default true |
| `visible` | Boolean | Soft-delete flag |
| `createdAt` | Date | Auto |
| `updatedAt` | Date | Auto |

**Note:** News has both `hidden` and `visible` fields - `hidden` defaults to true (announcements start hidden), `visible` is the soft-delete flag.

---

## API Endpoints

### Banners

```
GET /api/banner
Auth: JWT
Response: { success: true, data: [Banner...] }
```
- Filtered by user's `companyName`

```
POST /api/banner
Auth: JWT
Body: { name, slug, description, companyName }
```

```
POST /api/banner/uploadBanner
Auth: JWT + multer
Body: multipart form with image + banner fields
```
- Creates banner with image upload

```
GET /api/banner/getBanners
Auth: JWT
```
- Gets single company banner

```
GET /api/banner/:id
PUT /api/banner/:id (with optional multer image)
DELETE /api/banner/:id (soft-delete)
```

### Announcements (News)

```
GET /api/news
Auth: JWT
Response: { success: true, data: [News...] }
```
- Filtered by user's `companyName`

```
POST /api/news
Auth: JWT
Body: { title, content, image?, companyName }
```

```
GET /api/news/:id
PUT /api/news/:id
DELETE /api/news/:id (soft-delete)
```

---

## Flutter Domain Models

### CompanyBanners
```dart
class CompanyBanners {
  bool success;
  List<Banner> banners;
}
```

### Banner
```dart
class Banner {
  String id;
  String name;
  String slug;
  String image;
  String description;
  bool isActive;
  String companyName;
}
```

### Announcements
```dart
class Announcements {
  List<Announcement> announcement;
}
```

### Announcement
```dart
class Announcement {
  String id;
  String title;
  String content;
  String createdAt;
}
```

---

## Repository Interfaces

### BannersRepository
```dart
abstract class BannersRepository {
  Future<Result<CompanyBanners, Exception>> getBanners();
}
```

### CompanyFeedsRepository (announcement method)
```dart
Future<Result<Announcements, Exception>> getCompanyAnnouncements();
```

---

## Use Cases

| Use Case | Description |
|----------|-------------|
| `GetCompanyBannersUseCase` | Fetches banners for user's company |
| `GetCompanyAnnouncementsUseCase` | Fetches news/announcements for user's company |

---

## UI Display

### Banners
- Displayed in `HomeScreen` as a carousel (`infinite_carousel` or `carousel_slider`)
- Auto-scrolling image carousel at the top of the feed tab
- Each banner shows image, tappable

### Announcements
- Displayed in the home screen feed area
- Shows title and content
- Loaded in parallel with feed on HomeViewModel initialization

---

## Key Business Rules for Supabase Migration

1. **Banners are company-scoped** via `companyName`
2. **Banner images** need Supabase Storage migration
3. **News has dual visibility** - `hidden` (content visibility) + `visible` (soft-delete) - Simplify in Supabase
4. **Both are read-only from client** - Only admin creates/manages them
5. **Loaded in parallel** on home screen initialization
6. **No pagination** on either endpoint - All banners/announcements loaded at once
