# AI Features (Gemini Integration)

## Overview

Bondly integrates Google Gemini AI (model: `gemini-3-flash-preview`) for three features: personalized feed ordering, reward recommendations, and sentiment analysis on feed posts. These are client-side AI calls (not backend).

---

## Architecture

- **Service:** `GeminiService` - Wraps `google_generative_ai` package
- **Model:** `gemini-3-flash-preview`
- **API Key:** From `.env` file (`GEMINI_API_KEY`)
- **All AI processing happens on the Flutter client** - No backend AI endpoints

---

## Domain Models

### FeedInsight
```dart
class FeedInsight {
  String feedId;
  double relevanceScore;
  String reason;
}
```

### PersonalizedFeedResult
```dart
class PersonalizedFeedResult {
  List<String> orderedFeedIds;
  Map<String, FeedInsight> insights;
}
```

### RewardRecommendation
```dart
class RewardRecommendation {
  String rewardId;
  String reason;
  double matchScore;
}
```

### SentimentResult
```dart
class SentimentResult {
  SentimentType sentiment;  // positive, neutral, negative
  double confidence;
  String summary;
}
```

---

## Repository Interface

### AIRepository
```dart
abstract class AIRepository {
  Future<Result<PersonalizedFeedResult, Exception>> personalizeFeed(
    String userId,
    List<FeedData> feedItems,
    User userProfile,
  );

  Future<Result<List<RewardRecommendation>, Exception>> getRewardRecommendations(
    User userProfile,
    List<Reward> availableRewards,
  );

  Future<Result<SentimentResult, Exception>> analyzeSentiment(String text);
}
```

---

## Use Cases

| Use Case | Description |
|----------|-------------|
| `PersonalizeFeedUseCase` | Sends feed items + user profile to Gemini, gets relevance-ordered feed IDs |
| `GetRewardRecommendationsUseCase` | Sends user profile + available rewards to Gemini, gets recommended reward IDs with reasons |
| `AnalyzeSentimentUseCase` | Analyzes text sentiment (positive/neutral/negative) with confidence score |

---

## How Each Feature Works

### 1. Feed Personalization
- **Trigger:** User toggles "AI Personalization" banner on feed tab
- **Input:** All feed items + user profile (name, role, department, points)
- **Process:** Gemini analyzes feed content relevance to the user
- **Output:** Reordered list of feed IDs by relevance score + reasons
- **UI:** Feed is reordered; insights can be shown per post
- **Cached:** Results stored in ViewModel during session

### 2. Reward Recommendations
- **Trigger:** When rewards catalog loads in MyRewardsScreen
- **Input:** User profile + all available rewards
- **Process:** Gemini suggests rewards based on user preferences/profile
- **Output:** List of reward IDs with match scores and reasons
- **UI:** `AIRecommendationCard` widgets shown at top of rewards grid
- **Cached:** Results stored in ViewModel during session

### 3. Sentiment Analysis
- **Trigger:** Per feed post, on demand or automatic
- **Input:** Feed post body text
- **Process:** Gemini classifies sentiment
- **Output:** Sentiment type (positive/neutral/negative), confidence, summary
- **UI:** `SentimentBadge` widget on each feed post (color-coded)
- **Cached:** `sentimentCache: Map<String, SentimentResult>` in HomeViewModel

---

## UI Widgets

### `feed_personalization_banner.dart`
- Toggle switch for AI-powered feed ordering
- Shows "Personalizar feed con IA" label

### `ai_recommendation_card.dart`
- Card showing recommended reward with reason and match score
- Displays at top of rewards catalog

### `sentiment_badge.dart`
- Small badge overlay on feed posts
- Color-coded: green (positive), gray (neutral), red (negative)
- Shows confidence percentage

---

## Key Considerations for Supabase Migration

1. **AI is client-side only** - No backend changes needed for basic functionality
2. **Gemini API key** is in `.env` - Consider moving to Supabase Edge Functions for security
3. **No AI data is persisted** - All results are session-cached only
4. **Feed personalization** depends on feed data structure remaining compatible
5. **Reward recommendations** depend on reward model structure
6. **Sentiment analysis** is text-only, model-agnostic
7. **Consider server-side AI** for: caching results, reducing API costs, consistent scoring
8. **Rate limiting** - Gemini API has quotas; client-side calls multiply with users
