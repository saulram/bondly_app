import 'package:bondly_app/features/ai/domain/models/feed_insight.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedInsight', () {
    test('fromJson creates instance with valid data', () {
      final json = {
        'feedId': 'feed_123',
        'relevanceScore': 0.95,
        'reason': 'High engagement post',
      };

      final insight = FeedInsight.fromJson(json);

      expect(insight.feedId, 'feed_123');
      expect(insight.relevanceScore, 0.95);
      expect(insight.reason, 'High engagement post');
    });

    test('fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};

      final insight = FeedInsight.fromJson(json);

      expect(insight.feedId, '');
      expect(insight.relevanceScore, 0.0);
      expect(insight.reason, '');
    });

    test('fromJson handles null values with defaults', () {
      final json = {
        'feedId': null,
        'relevanceScore': null,
        'reason': null,
      };

      final insight = FeedInsight.fromJson(json);

      expect(insight.feedId, '');
      expect(insight.relevanceScore, 0.0);
      expect(insight.reason, '');
    });

    test('fromJson converts int relevanceScore to double', () {
      final json = {
        'feedId': 'feed_1',
        'relevanceScore': 1,
        'reason': 'reason',
      };

      final insight = FeedInsight.fromJson(json);

      expect(insight.relevanceScore, 1.0);
      expect(insight.relevanceScore, isA<double>());
    });
  });

  group('PersonalizedFeedResult', () {
    test('creates instance with ordered IDs and insights', () {
      final insight = FeedInsight(
        feedId: 'feed_1',
        relevanceScore: 0.9,
        reason: 'Popular',
      );

      final result = PersonalizedFeedResult(
        orderedFeedIds: ['feed_1', 'feed_2'],
        insights: {'feed_1': insight},
      );

      expect(result.orderedFeedIds, hasLength(2));
      expect(result.orderedFeedIds.first, 'feed_1');
      expect(result.insights['feed_1']?.relevanceScore, 0.9);
    });

    test('creates instance with empty data', () {
      final result = PersonalizedFeedResult(
        orderedFeedIds: [],
        insights: {},
      );

      expect(result.orderedFeedIds, isEmpty);
      expect(result.insights, isEmpty);
    });
  });
}
