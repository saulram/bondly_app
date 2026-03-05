# Points Economy & Account Statement Feature

## Overview

Bondly has a dual-point system: `giftedPoints` (points to give via recognitions) and `pointsReceived` (points earned from being recognized, spendable on rewards). Points are refreshed monthly, and account statements track all transactions.

---

## Points Architecture

### Two Point Types

| Point Type | Field | Purpose | How Earned | How Spent |
|-----------|-------|---------|------------|-----------|
| **Gifted Points** | `giftedPoints` | Points to give to others | Monthly refill from `monthlyPoints` | Sending recognitions |
| **Received Points** | `pointsReceived` | Points to spend on rewards | Receiving recognitions | Cart checkout |

### Monthly Budget
- `monthlyPoints` - Set per user (based on plan/company config)
- Each month, `giftedPoints` is reset to `monthlyPoints`
- `pointsReceived` accumulates and is never reset (only reduced by purchases)

### Initial Values (New User)
- **Creator:** `giftedPoints = 0`, `pointsReceived = 0`
- **Invitee:** `giftedPoints = monthlyPoints`, `pointsReceived = 350`

---

## Point Transactions

### Recognition (Acknowledgment)
- **Sender:** `giftedPoints -= badge.value * recipients.length`
- **Each Recipient:** `pointsReceived += badge.value`
- Validation: `sender.giftedPoints >= totalPoints`

### Cart Checkout
- **Buyer:** `pointsReceived -= cart.total`
- Validation: `buyer.pointsReceived >= cart.total`

### Monthly Refill (Cron Job)
- **Schedule:** `0 0 1 * *` (midnight on 1st of every month)
- **Action:** For every user: `giftedPoints = monthlyPoints`
- Does NOT affect `pointsReceived`

### Bulk Gift (Admin/Debug)
```
POST /api/users/gift
Auth: None (!)
Body: { companyName }
```
- Sets ALL users in company: `giftedPoints = 100000`, `pointsReceived = 100000`
- **No authentication required** - debug/admin tool

---

## Database Schemas (MongoDB)

### AccountStatement (`models/AccountStatement.model.js`)

| Field | Type | Description |
|-------|------|-------------|
| `user` | ObjectId ref User | Required |
| `date` | Date | Statement period (required) |
| `transactions` | Array | See below |
| `balance` | Number | Running balance (required) |
| `description` | String | Statement description (required) |
| `createdAt` | Date | Auto |
| `updatedAt` | Date | Auto |

**Transaction subdocument:**
```
{
  name: String,
  amount: Number,
  type: Enum ['Recompensa', 'Reconocimiento', 'Saldo Anterior'],
  date: Date
}
```

### UserPoints (`models/UserPoints.js`)

| Field | Type | Description |
|-------|------|-------------|
| `user_id` | ObjectId ref User | |
| `earned` | Number | |
| `toGive` | Number | |
| `lastRefill` | Date | |
| `refillAmount` | Number | |

**Note:** This model exists but may not be actively used in the main flows. The primary point tracking is on the User model itself.

### UserBalance (`models/UserBalance.js`)

| Field | Type | Description |
|-------|------|-------------|
| `user_id` | ObjectId ref User | |
| `period` | String | |
| `initial_balance` | Number | |
| `final_balance` | Number | |

**Note:** Has a bug - exports `mongoose.model('UserBalance', UserSchema)` referencing undefined `UserSchema`. May not be functional.

---

## Account Statement Generation

**File:** `controllers/services/account_statement.service.js`

**Logic for generating monthly statement:**

1. Get all Exchanges for the user in the requested month -> negative "Recompensa" transactions
2. Get all Acknowledgments where user is a recipient in the requested month -> positive "Reconocimiento" transactions
3. Look up the previous month's statement -> include as "Saldo Anterior" transaction
4. Calculate running balance
5. Store/update in AccountStatement collection

**Transaction types:**
- `Reconocimiento` - Points received from being recognized (positive)
- `Recompensa` - Points spent on rewards/exchanges (negative)
- `Saldo Anterior` - Previous month's ending balance (carried forward)

---

## API Endpoints

```
GET /api/accountStatement
Auth: JWT
Response: { success: true, data: AccountStatement }
```
- Returns current month's statement for authenticated user
- Generates/updates statement on the fly

```
GET /api/accountStatement/:date
Auth: JWT
Response: { success: true, data: AccountStatement }
```
- Returns statement for a specific month (date format)

---

## Flutter Domain Models

### AccountStatement
```dart
class AccountStatement {
  String user;
  String date;
  List<Transaction> transactions;
  int balance;
  String description;
  String id;
}
```

### Transaction
```dart
class Transaction {
  String name;
  int amount;
  String type;    // 'Recompensa', 'Reconocimiento', 'Saldo Anterior'
  String date;
  String? id;
}
```

---

## Repository Interface

### AccountStatementRepository
```dart
abstract class AccountStatementRepository {
  Future<Result<AccountStatement, Exception>> getAccountStatement();
}
```

---

## Use Cases

| Use Case | Description |
|----------|-------------|
| `GetAccountStatementUseCase` | Fetches current month's account statement |

---

## UI Screens

### MonthlyBalanceScreen (`/monthly-balance`)
- Shows account statement for current month
- Displays balance at top
- Lists transactions: recognitions received (positive), rewards redeemed (negative)
- Each transaction shows: name, amount, type, date

### ProfileScreen (balance display)
- Shows `pointsReceived` as "spendable balance"
- Fetched from account statement or user object

---

## AccountStatementViewModel (Factory)

- `statement: AccountStatement?` - Current statement
- `loadStatement()` - Fetches via `GetAccountStatementUseCase`

---

## Key Business Rules for Supabase Migration

1. **Dual point system** must be maintained - `giftedPoints` and `pointsReceived` are separate
2. **Monthly refill** needs pg_cron or Edge Function to reset `giftedPoints`
3. **Account statements** are generated on-demand, not pre-computed - Consider materialized views or functions
4. **Transaction history** pulls from Exchanges (negative) and Acknowledgments (positive)
5. **Previous balance** is looked up from prior month's statement - Recursive dependency
6. **pointsReceived starts at 350** for new invitees - Initial seed value
7. **No overdraft protection** beyond validation checks - Need database constraints
8. **Bulk gift endpoint has no auth** - Security concern to address in Supabase
9. **UserPoints and UserBalance models** may be redundant with User model fields - Evaluate if needed
10. **Points are integers** - No fractional points
