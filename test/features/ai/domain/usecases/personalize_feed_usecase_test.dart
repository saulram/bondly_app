import 'package:bondly_app/features/ai/domain/models/feed_insight.dart';
import 'package:bondly_app/features/ai/domain/repositories/ai_repository.dart';
import 'package:bondly_app/features/ai/domain/usecases/personalize_feed_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockAIRepository extends Mock implements AIRepository {}

void main() {
  late PersonalizeFeedUseCase useCase;
  late MockAIRepository mockRepository;

  setUp(() {
    mockRepository = MockAIRepository();
    useCase = PersonalizeFeedUseCase(mockRepository);
  });

  group('PersonalizeFeedUseCase', () {
    final testUserId = 'user_123';
    final testFeedItems = [
      {'id': 'feed_1', 'header': 'Post 1', 'body': 'Body 1'},
      {'id': 'feed_2', 'header': 'Post 2', 'body': 'Body 2'},
    ];
    final testUserProfile = {
      'name': 'Test User',
      'monthlyPoints': 100,
      'pointsReceived': 50,
      'company': 'TestCo',
    };

    test('returns success with personalized feed result', () async {
      final expectedResult = PersonalizedFeedResult(
        orderedFeedIds: ['feed_2', 'feed_1'],
        insights: {
          'feed_2': FeedInsight(
            feedId: 'feed_2',
            relevanceScore: 0.95,
            reason: 'Most relevant',
          ),
        },
      );

      when(() => mockRepository.personalizeFeed(
            userId: any(named: 'userId'),
            feedItems: any(named: 'feedItems'),
            userProfile: any(named: 'userProfile'),
          )).thenAnswer((_) async => Result.success(expectedResult));

      final result = await useCase.invoke(
        userId: testUserId,
        feedItems: testFeedItems,
        userProfile: testUserProfile,
      );

      result.when(
        (success) {
          expect(success.orderedFeedIds, ['feed_2', 'feed_1']);
          expect(success.insights.containsKey('feed_2'), isTrue);
        },
        (error) => fail('Expected success but got error: $error'),
      );

      verify(() => mockRepository.personalizeFeed(
            userId: testUserId,
            feedItems: testFeedItems,
            userProfile: testUserProfile,
          )).called(1);
    });

    test('returns error when repository fails', () async {
      when(() => mockRepository.personalizeFeed(
            userId: any(named: 'userId'),
            feedItems: any(named: 'feedItems'),
            userProfile: any(named: 'userProfile'),
          )).thenAnswer(
        (_) async => Result.error(Exception('Network error')),
      );

      final result = await useCase.invoke(
        userId: testUserId,
        feedItems: testFeedItems,
        userProfile: testUserProfile,
      );

      result.when(
        (success) => fail('Expected error but got success'),
        (error) => expect(error, isA<Exception>()),
      );
    });

    test('delegates to repository with correct parameters', () async {
      when(() => mockRepository.personalizeFeed(
            userId: any(named: 'userId'),
            feedItems: any(named: 'feedItems'),
            userProfile: any(named: 'userProfile'),
          )).thenAnswer(
        (_) async => Result.success(
          PersonalizedFeedResult(orderedFeedIds: [], insights: {}),
        ),
      );

      await useCase.invoke(
        userId: 'specific_user',
        feedItems: [{'id': 'item1'}],
        userProfile: {'name': 'Specific'},
      );

      verify(() => mockRepository.personalizeFeed(
            userId: 'specific_user',
            feedItems: [{'id': 'item1'}],
            userProfile: {'name': 'Specific'},
          )).called(1);
    });
  });
}
