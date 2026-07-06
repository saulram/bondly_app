import 'package:bondly_app/features/ai/domain/models/reward_recommendation.dart';
import 'package:bondly_app/features/ai/domain/repositories/ai_repository.dart';
import 'package:bondly_app/features/ai/domain/usecases/get_reward_recommendations_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockAIRepository extends Mock implements AIRepository {}

void main() {
  late GetRewardRecommendationsUseCase useCase;
  late MockAIRepository mockRepository;

  setUp(() {
    mockRepository = MockAIRepository();
    useCase = GetRewardRecommendationsUseCase(mockRepository);
  });

  group('GetRewardRecommendationsUseCase', () {
    final testUserProfile = {
      'name': 'Test User',
      'availablePoints': 500,
      'monthlyPoints': 100,
      'company': 'TestCo',
    };
    final testRewards = [
      {'id': 'r1', 'name': 'Gift Card', 'points': 200},
      {'id': 'r2', 'name': 'Headphones', 'points': 400},
    ];

    test('returns success with recommendations list', () async {
      final expectedRecommendations = [
        RewardRecommendation(
          rewardId: 'r1',
          reason: 'Perfect for your points',
          matchScore: 0.95,
        ),
        RewardRecommendation(
          rewardId: 'r2',
          reason: 'Popular choice',
          matchScore: 0.80,
        ),
      ];

      when(() => mockRepository.getRewardRecommendations(
            userProfile: any(named: 'userProfile'),
            availableRewards: any(named: 'availableRewards'),
          )).thenAnswer((_) async => Result.success(expectedRecommendations));

      final result = await useCase.invoke(
        userProfile: testUserProfile,
        availableRewards: testRewards,
      );

      result.when(
        (success) {
          expect(success, hasLength(2));
          expect(success.first.rewardId, 'r1');
          expect(success.last.matchScore, 0.80);
        },
        (error) => fail('Expected success but got error: $error'),
      );

      verify(() => mockRepository.getRewardRecommendations(
            userProfile: testUserProfile,
            availableRewards: testRewards,
          )).called(1);
    });

    test('returns success with empty list when no recommendations', () async {
      when(() => mockRepository.getRewardRecommendations(
            userProfile: any(named: 'userProfile'),
            availableRewards: any(named: 'availableRewards'),
          )).thenAnswer((_) async => Result.success([]));

      final result = await useCase.invoke(
        userProfile: testUserProfile,
        availableRewards: testRewards,
      );

      result.when(
        (success) => expect(success, isEmpty),
        (error) => fail('Expected success but got error: $error'),
      );
    });

    test('returns error when repository fails', () async {
      when(() => mockRepository.getRewardRecommendations(
            userProfile: any(named: 'userProfile'),
            availableRewards: any(named: 'availableRewards'),
          )).thenAnswer(
        (_) async => Result.error(Exception('API error')),
      );

      final result = await useCase.invoke(
        userProfile: testUserProfile,
        availableRewards: testRewards,
      );

      result.when(
        (success) => fail('Expected error but got success'),
        (error) => expect(error, isA<Exception>()),
      );
    });
  });
}
