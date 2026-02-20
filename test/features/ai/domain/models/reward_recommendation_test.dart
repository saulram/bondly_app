import 'package:bondly_app/features/ai/domain/models/reward_recommendation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RewardRecommendation', () {
    test('fromJson creates instance with valid data', () {
      final json = {
        'rewardId': 'reward_123',
        'reason': 'Ideal para ti por tus puntos',
        'matchScore': 0.92,
      };

      final rec = RewardRecommendation.fromJson(json);

      expect(rec.rewardId, 'reward_123');
      expect(rec.reason, 'Ideal para ti por tus puntos');
      expect(rec.matchScore, 0.92);
    });

    test('fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};

      final rec = RewardRecommendation.fromJson(json);

      expect(rec.rewardId, '');
      expect(rec.reason, '');
      expect(rec.matchScore, 0.0);
    });

    test('fromJson handles null values with defaults', () {
      final json = {
        'rewardId': null,
        'reason': null,
        'matchScore': null,
      };

      final rec = RewardRecommendation.fromJson(json);

      expect(rec.rewardId, '');
      expect(rec.reason, '');
      expect(rec.matchScore, 0.0);
    });

    test('fromJson converts int matchScore to double', () {
      final json = {
        'rewardId': 'r1',
        'reason': 'test',
        'matchScore': 1,
      };

      final rec = RewardRecommendation.fromJson(json);

      expect(rec.matchScore, 1.0);
      expect(rec.matchScore, isA<double>());
    });

    test('constructor creates instance correctly', () {
      final rec = RewardRecommendation(
        rewardId: 'abc',
        reason: 'Great match',
        matchScore: 0.75,
      );

      expect(rec.rewardId, 'abc');
      expect(rec.reason, 'Great match');
      expect(rec.matchScore, 0.75);
    });
  });
}
