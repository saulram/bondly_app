import 'package:bondly_app/features/ai/data/api/gemini_service.dart';
import 'package:bondly_app/features/ai/data/repositories/default_ai_repository.dart';
import 'package:bondly_app/features/ai/domain/models/feed_insight.dart';
import 'package:bondly_app/features/ai/domain/models/reward_recommendation.dart';
import 'package:bondly_app/features/ai/domain/models/sentiment_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGeminiService extends Mock implements GeminiService {}

void main() {
  late DefaultAIRepository repository;
  late MockGeminiService mockGeminiService;

  setUp(() {
    mockGeminiService = MockGeminiService();
    repository = DefaultAIRepository(mockGeminiService);
  });

  group('personalizeFeed', () {
    final testFeedItems = [
      {
        'id': 'feed_1',
        'header': 'Great work!',
        'body': 'Congratulations on the achievement',
        'type': 'recognition',
        'likesCount': 5,
        'commentsCount': 2,
        'senderName': 'John Doe',
      },
      {
        'id': 'feed_2',
        'header': 'Team update',
        'body': 'New project kickoff',
        'type': 'announcement',
        'likesCount': 3,
        'commentsCount': 1,
        'senderName': 'Jane Smith',
      },
    ];
    final testUserProfile = {
      'name': 'Test User',
      'monthlyPoints': 100,
      'pointsReceived': 50,
      'company': 'TestCo',
    };

    test('returns success with personalized feed on valid response', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {
                'orderedIds': ['feed_2', 'feed_1'],
                'insights': {
                  'feed_2': {
                    'feedId': 'feed_2',
                    'relevanceScore': 0.95,
                    'reason': 'Más relevante'
                  },
                  'feed_1': {
                    'feedId': 'feed_1',
                    'relevanceScore': 0.8,
                    'reason': 'Popular'
                  },
                }
              });

      final result = await repository.personalizeFeed(
        userId: 'user_1',
        feedItems: testFeedItems,
        userProfile: testUserProfile,
      );

      result.when(
        (success) {
          expect(success, isA<PersonalizedFeedResult>());
          expect(success.orderedFeedIds, ['feed_2', 'feed_1']);
          expect(success.insights, hasLength(2));
          expect(success.insights['feed_2']?.relevanceScore, 0.95);
        },
        (error) => fail('Expected success but got error: $error'),
      );
    });

    test('returns success with fallback order when orderedIds is null',
        () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {
                'orderedIds': null,
                'insights': {},
              });

      final result = await repository.personalizeFeed(
        userId: 'user_1',
        feedItems: testFeedItems,
        userProfile: testUserProfile,
      );

      result.when(
        (success) {
          expect(success.orderedFeedIds, ['feed_1', 'feed_2']);
        },
        (error) => fail('Expected success but got error: $error'),
      );
    });

    test('returns error when gemini service throws', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenThrow(GeminiServiceException('API error'));

      final result = await repository.personalizeFeed(
        userId: 'user_1',
        feedItems: testFeedItems,
        userProfile: testUserProfile,
      );

      result.when(
        (success) => fail('Expected error but got success'),
        (error) => expect(error, isA<Exception>()),
      );
    });

    test('sends prompt containing user profile data', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {
                'orderedIds': ['feed_1'],
                'insights': {},
              });

      await repository.personalizeFeed(
        userId: 'user_1',
        feedItems: testFeedItems,
        userProfile: testUserProfile,
      );

      final captured =
          verify(() => mockGeminiService.generateJsonResponse(captureAny()))
              .captured;
      final prompt = captured.first as String;
      expect(prompt, contains('Test User'));
      expect(prompt, contains('100'));
      expect(prompt, contains('TestCo'));
    });

    test('limits feed items to 20', () async {
      final manyItems = List.generate(
        25,
        (i) => {
          'id': 'feed_$i',
          'header': 'Post $i',
          'body': 'Body $i',
          'type': 'post',
          'likesCount': 0,
          'commentsCount': 0,
          'senderName': 'User $i',
        },
      );

      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {
                'orderedIds': [],
                'insights': {},
              });

      await repository.personalizeFeed(
        userId: 'user_1',
        feedItems: manyItems,
        userProfile: testUserProfile,
      );

      // The prompt should only contain the first 20 items
      final captured =
          verify(() => mockGeminiService.generateJsonResponse(captureAny()))
              .captured;
      final prompt = captured.first as String;
      expect(prompt, contains('feed_19'));
      expect(prompt, isNot(contains('feed_20')));
    });
  });

  group('getRewardRecommendations', () {
    final testUserProfile = {
      'name': 'Test User',
      'availablePoints': 500,
      'monthlyPoints': 100,
      'company': 'TestCo',
    };
    final testRewards = [
      {
        'id': 'r1',
        'name': 'Gift Card',
        'description': 'A nice gift card',
        'points': 200,
        'category': 'gifts',
        'likesCount': 10,
      },
    ];

    test('returns success with recommendations list', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {
                'recommendations': [
                  {
                    'rewardId': 'r1',
                    'reason': 'Perfecto para ti',
                    'matchScore': 0.92
                  },
                ]
              });

      final result = await repository.getRewardRecommendations(
        userProfile: testUserProfile,
        availableRewards: testRewards,
      );

      result.when(
        (success) {
          expect(success, isA<List<RewardRecommendation>>());
          expect(success, hasLength(1));
          expect(success.first.rewardId, 'r1');
          expect(success.first.matchScore, 0.92);
        },
        (error) => fail('Expected success but got error: $error'),
      );
    });

    test('returns empty list when recommendations is null', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {
                'recommendations': null,
              });

      final result = await repository.getRewardRecommendations(
        userProfile: testUserProfile,
        availableRewards: testRewards,
      );

      result.when(
        (success) => expect(success, isEmpty),
        (error) => fail('Expected success but got error: $error'),
      );
    });

    test('returns error when gemini service throws', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenThrow(GeminiServiceException('Quota exceeded'));

      final result = await repository.getRewardRecommendations(
        userProfile: testUserProfile,
        availableRewards: testRewards,
      );

      result.when(
        (success) => fail('Expected error but got success'),
        (error) => expect(error, isA<Exception>()),
      );
    });

    test('sends prompt containing user profile and rewards', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {'recommendations': []});

      await repository.getRewardRecommendations(
        userProfile: testUserProfile,
        availableRewards: testRewards,
      );

      final captured =
          verify(() => mockGeminiService.generateJsonResponse(captureAny()))
              .captured;
      final prompt = captured.first as String;
      expect(prompt, contains('Test User'));
      expect(prompt, contains('500'));
      expect(prompt, contains('Gift Card'));
    });

    test('limits rewards to 15', () async {
      final manyRewards = List.generate(
        20,
        (i) => {
          'id': 'r_$i',
          'name': 'Reward $i',
          'description': 'Description $i',
          'points': 100 * i,
          'category': 'cat',
          'likesCount': i,
        },
      );

      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {'recommendations': []});

      await repository.getRewardRecommendations(
        userProfile: testUserProfile,
        availableRewards: manyRewards,
      );

      final captured =
          verify(() => mockGeminiService.generateJsonResponse(captureAny()))
              .captured;
      final prompt = captured.first as String;
      expect(prompt, contains('Reward 14'));
      expect(prompt, isNot(contains('Reward 15')));
    });
  });

  group('analyzeSentiment', () {
    test('returns positive sentiment on valid response', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {
                'sentiment': 'positive',
                'confidence': 0.92,
                'summary': 'Mensaje muy positivo',
              });

      final result = await repository.analyzeSentiment(
        text: 'Excelente trabajo equipo!',
      );

      result.when(
        (success) {
          expect(success, isA<SentimentResult>());
          expect(success.sentiment, SentimentType.positive);
          expect(success.confidence, 0.92);
          expect(success.summary, 'Mensaje muy positivo');
        },
        (error) => fail('Expected success but got error: $error'),
      );
    });

    test('returns negative sentiment', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {
                'sentiment': 'negative',
                'confidence': 0.78,
                'summary': 'Tono negativo',
              });

      final result = await repository.analyzeSentiment(
        text: 'Esto no funciona bien',
      );

      result.when(
        (success) {
          expect(success.sentiment, SentimentType.negative);
          expect(success.confidence, 0.78);
        },
        (error) => fail('Expected success but got error: $error'),
      );
    });

    test('defaults to neutral when sentiment field is null', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {
                'sentiment': null,
                'confidence': null,
                'summary': null,
              });

      final result = await repository.analyzeSentiment(text: 'test');

      result.when(
        (success) {
          expect(success.sentiment, SentimentType.neutral);
          expect(success.confidence, 0.5);
          expect(success.summary, 'Sin análisis disponible');
        },
        (error) => fail('Expected success but got error: $error'),
      );
    });

    test('returns error when gemini service throws', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenThrow(GeminiServiceException('Rate limited'));

      final result = await repository.analyzeSentiment(text: 'test');

      result.when(
        (success) => fail('Expected error but got success'),
        (error) => expect(error, isA<Exception>()),
      );
    });

    test('sends prompt containing the text to analyze', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {
                'sentiment': 'neutral',
                'confidence': 0.5,
                'summary': 'Neutral',
              });

      await repository.analyzeSentiment(
        text: 'Un mensaje específico para analizar',
      );

      final captured =
          verify(() => mockGeminiService.generateJsonResponse(captureAny()))
              .captured;
      final prompt = captured.first as String;
      expect(prompt, contains('Un mensaje específico para analizar'));
    });

    test('handles integer confidence values', () async {
      when(() => mockGeminiService.generateJsonResponse(any()))
          .thenAnswer((_) async => {
                'sentiment': 'positive',
                'confidence': 1,
                'summary': 'Positivo',
              });

      final result = await repository.analyzeSentiment(text: 'test');

      result.when(
        (success) {
          expect(success.confidence, 1.0);
          expect(success.confidence, isA<double>());
        },
        (error) => fail('Expected success but got error: $error'),
      );
    });
  });
}
