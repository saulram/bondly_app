# Rewards & Shopping Cart Feature

## Overview

Users can browse a rewards catalog (gift cards, experiences, incentives) and purchase items using their `pointsReceived`. The cart system supports adding/removing items, bulk operations, and checkout which creates exchange records and deducts points.

---

## Database Schemas (MongoDB)

### Reward (`models/Reward.js`)

| Field | Type | Description |
|-------|------|-------------|
| `name` | String | Reward name |
| `description` | String | Reward description |
| `category` | String | Category (e.g., "Gift Cards", "Experiences", "Incentives") |
| `points` | Number | Cost in points |
| `image` | String | File path to image |
| `deadline` | Date | Expiration date |
| `companyName` | String | Company scope |
| `account` | Number | Account number |
| `likes` | Array | `[{ user_id: ObjectId }]` |
| `enable` | Boolean | Default true |
| `visible` | Boolean | Soft-delete flag |
| `createdAt` | Date | Auto |
| `updatedAt` | Date | Auto |

**Virtual field:** `imageUrl` -> `https://api.bondly.mx/${this.image}`

### Cart (`models/Cart.js`)

| Field | Type | Description |
|-------|------|-------------|
| `user_id` | ObjectId ref User | Cart owner |
| `rewards` | Array | `[{ reward: ObjectId ref Reward, quantity: Number (default 1) }]` |
| `total` | Number | Sum of `quantity * reward.points` (default 0) |
| `type` | Enum | `cart`, `wishList` (default `cart`) |
| `companyName` | String | Company scope |
| `createdAt` | Date | Auto |
| `updatedAt` | Date | Auto |

### Exchange (`models/Exchange.js`)

| Field | Type | Description |
|-------|------|-------------|
| `user_id` | ObjectId ref User | Who redeemed |
| `reward` | ObjectId ref Reward | What was redeemed |
| `code` | String | Random 10-char alphanumeric redemption code |
| `status` | Enum | `Entregado`, `En espera`, `Recibido`, `Devolucion` (default `En espera`) |
| `companyName` | String | Company scope |
| `createdAt` | Date | Auto |
| `updatedAt` | Date | Auto |

---

## API Endpoints

### Rewards Catalog

```
GET /api/reward
Auth: JWT
Response: { success: true, data: [Reward...] }
```
- Filtered by user's `companyName`
- Populates `imageUrl` virtual

```
GET /api/reward/category/:category
Auth: JWT
```
- Rewards filtered by category for user's company

```
POST /api/reward
Auth: JWT + multer (image upload)
Body: { name, description, category, points, deadline, companyName }
```
- Also creates a feed entry of type `recompensa`

```
GET /api/reward/:id
PUT /api/reward/:id (with optional image upload)
DELETE /api/reward/:id (soft-delete)
```

### Cart Operations

```
GET /api/cart/user
Auth: JWT
Response: { success: true, data: Cart (populated rewards) }
```
- Returns the authenticated user's cart with rewards populated

```
PUT /api/cart/:cartId/push/:rewardId/:quantity?
Auth: JWT
```
- Adds reward to cart or increments quantity
- Recalculates total
- Default quantity: 1

```
PUT /api/cart/:cartId/pull/:rewardId/:quantity?
Auth: JWT
```
- Decrements quantity or removes reward from cart
- Recalculates total

```
PUT /api/cart/:cartId/bulkAdd
Auth: JWT
Body: { rewards: [{ reward: rewardId, quantity: N }, ...] }
```
- Replaces all cart items at once
- Recalculates total

```
DELETE /api/cart/user/:cartId
Auth: JWT
```
- Empties cart: clears rewards array, sets total to 0

### Checkout

```
POST /api/cart/checkout/:cartId
Auth: JWT
Response: { success: true, data: [Exchange...] }
```

**Checkout business logic (`cart.service.js` + `exchange.service.js`):**

1. Fetch cart with populated rewards
2. Verify `user.pointsReceived >= cart.total`
3. For each reward in cart:
   a. Create Exchange record with random 10-char code, status `En espera`
   b. Create AccountFeed entry (type: `canje`, header: "Ha canjeado una recompensa")
   c. Create Activity for user ("Has canjeado una recompensa", links to feed)
4. Deduct points: `user.pointsReceived -= cart.total`
5. Empty the cart (clear rewards, set total to 0)

### Exchange Management

```
GET /api/exchange/user
Auth: JWT
```
- User's own exchanges

```
POST /api/exchange/confirm
Auth: JWT
Body: { exchange details }
```
- Confirms exchange, creates feed + activity, deducts points

```
POST /api/exchange/report
Auth: JWT
Body: { startDate, endDate }
```
- Generates CSV report of exchanges for date range

**Exchange status flow:** `En espera` -> `Entregado` -> `Recibido` (or `Devolucion`)

---

## Flutter Domain Models

### Reward
```dart
class Reward {
  String id;
  String name;
  String description;
  String category;
  int points;
  String image;
  String? deadline;
  String companyName;
  bool enable;
  bool visible;
  dynamic likes;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;  // Virtual: https://api.bondly.mx/{image}
}
```

### RewardList
```dart
class RewardList {
  List<Reward> rewards;
}
```

### UserCart
```dart
class UserCart {
  String id;
  String userId;
  List<CartItem> rewards;
  String type;
  String companyName;
  String? createdAt;
  String? updatedAt;
  int total;
}
```

### CartItem
```dart
class CartItem {
  Reward reward;
  int quantity;
  String? id;
}
```

---

## Repository Interface

### CartRepository
```dart
abstract class CartRepository {
  Future<Result<RewardList, Exception>> getShoppingItems();
  Future<Result<UserCart, Exception>> getUserShoppingCart();
  Future<Result<UserCart, Exception>> bulkAddCartItems(List<Map<String, dynamic>> items, String cartId);
  Future<Result<UserCart, Exception>> pushCartItem(String cartId, String itemId);
  Future<Result<UserCart, Exception>> pullCartItem(String cartId, String itemId);
  Future<Result<bool, Exception>> clearShoppingCart(String cartId);
  Future<Result<bool, Exception>> checkOutCart(String cartId);
}
```

---

## Use Cases

| Use Case | Description |
|----------|-------------|
| `GetShoppingItemsUseCase` | Fetches rewards catalog |
| `GetUserShoppingCartUseCase` | Gets user's current cart |
| `BulkAddCartItemsUseCase` | Replaces all cart items at once |
| `PushCartItemUseCase` | Increments item quantity in cart |
| `PullCartItemUseCase` | Decrements/removes item from cart |
| `ClearShoppingCartUseCase` | Empties the cart |
| `CheckOutCartUseCase` | Processes checkout |

---

## UI Screens & Flow

### MyRewardsScreen (`/my-rewards`)
- Loads rewards catalog + user cart + balance
- Displays rewards grid with name, image, points cost
- Category filter tabs: All, Experiences, Gift Cards, Incentives
- "Add to cart" button per reward
- Shows affordability (greyed out if insufficient points)
- AI recommendation cards (Gemini suggestions)
- Local cart persistence via SharedPreferences

### MyCartScreen (`/my-cart`)
- Shows cart items with quantities
- +/- buttons to adjust quantities (push/pull)
- Total points displayed
- "Checkout" button
- "Clear cart" option
- After checkout: clears local cart, navigates to home

---

## MyRewardsViewModel (Factory)

**Initialization:**
1. Load rewards catalog via `GetShoppingItemsUseCase`
2. Load user cart via `GetUserShoppingCartUseCase`
3. Load user balance
4. Load AI recommendations (optional)
5. Load local cart from SharedPreferences

**Key state:**
- `rewards: List<Reward>` - Full catalog
- `cartItems: List<CartItem>` - Current cart contents
- `cartId: String` - Server cart ID
- `localCartItems: List<Map>` - Locally persisted cart (SharedPreferences)
- `balance: int` - User's spendable points (pointsReceived)
- `recommendations: List<RewardRecommendation>` - AI suggestions
- `selectedCategory: String?` - Active filter

**Key methods:**
- `addToCart(reward)` - Adds to local list, saves to SharedPreferences, syncs via bulkAdd
- `removeFromCart(reward)` - Removes from local list, saves, syncs
- `incrementItem(cartItem)` - pushCartItem API call
- `decrementItem(cartItem)` - pullCartItem API call
- `checkout()` - checkOutCart API call, clears local storage
- `canAfford(reward)` - Checks `balance >= reward.points`

**Local cart persistence pattern:**
- Cart items saved as JSON in SharedPreferences under key `local_cart_items`
- On load, reads local cart first for instant display
- Syncs to server via `bulkAddCartItems` when changes occur
- Cleared on checkout

---

## Key Business Rules for Supabase Migration

1. **Cart is auto-created** when user is registered (one cart per user)
2. **Points check on checkout** - `pointsReceived >= cart.total`, fails otherwise
3. **Exchange codes** are random 10-char alphanumeric strings
4. **Checkout creates multiple side effects:**
   - Exchange records (one per reward)
   - Feed entries (one per reward, type `canje`)
   - Activity records (one per reward)
   - Points deduction from user
   - Cart emptied
5. **Cart total** is dynamically calculated as sum of `quantity * reward.points`
6. **BulkAdd replaces** all cart items (not appends)
7. **Reward images** are stored as relative paths, served with `https://api.bondly.mx/` prefix
8. **Creating a reward** also creates a feed entry (type `recompensa`)
9. **Local cart** on client provides offline resilience - must sync strategy for Supabase
10. **Exchange status progression:** `En espera` -> `Entregado` -> `Recibido` or `Devolucion`
