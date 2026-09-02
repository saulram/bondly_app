import 'package:bondly_app/features/ai/domain/models/feed_insight.dart';
import 'package:bondly_app/features/ai/domain/models/sentiment_result.dart';
import 'package:bondly_app/features/ai/domain/usecases/analyze_sentiment_usecase.dart';
import 'package:bondly_app/features/ai/domain/usecases/personalize_feed_usecase.dart';
import 'package:bondly_app/features/auth/domain/handlers/session_token_handler.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/domain/models/company_banners_model.dart';
import 'package:bondly_app/features/home/domain/usecases/create_acknowlegment.dart';
import 'package:bondly_app/features/home/domain/usecases/create_feed_comment.dart';
import 'package:bondly_app/features/home/domain/usecases/get_announcements.dart';
import 'package:bondly_app/features/home/domain/usecases/get_category_badges.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_banners.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_categories.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_collaborators.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_feeds.dart';
import 'package:bondly_app/features/home/domain/usecases/get_user_embassys.dart';
import 'package:bondly_app/features/home/domain/usecases/handle_like.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/ranking/domain/usecases/get_ranking_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

// Mocks for all HomeViewModel dependencies
class MockUserUseCase extends Mock implements UserUseCase {}

class MockSessionTokenHandler extends Mock implements SessionTokenHandler {}

class MockGetCompanyBannersUseCase extends Mock
    implements GetCompanyBannersUseCase {}

class MockGetCompanyFeedsUseCase extends Mock
    implements GetCompanyFeedsUseCase {}

class MockCreateFeedCommentUseCase extends Mock
    implements CreateFeedCommentUseCase {}

class MockHandleLikesUseCase extends Mock implements HandleLikesUseCase {}

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

class MockGetCategoryBadgesUseCase extends Mock
    implements GetCategoryBadgesUseCase {}

class MockGetCompanyCollaboratorsUseCase extends Mock
    implements GetCompanyCollaboratorsUseCase {}

class MockCreateAcknowledgmentUseCase extends Mock
    implements CreateAcknowledgmentUseCase {}

class MockGetCompanyAnnouncementsUseCase extends Mock
    implements GetCompanyAnnouncementsUseCase {}

class MockGetUserEmbassysUseCase extends Mock
    implements GetUserEmbassysUseCase {}

class MockGetRankingUseCase extends Mock implements GetRankingUseCase {}

class MockPersonalizeFeedUseCase extends Mock
    implements PersonalizeFeedUseCase {}

class MockAnalyzeSentimentUseCase extends Mock
    implements AnalyzeSentimentUseCase {}

// Helper to create a minimal Sender for test FeedData
Sender _testSender() => Sender(
      id: 'sender_1',
      completeName: 'John Doe',
      employeeNumber: 1,
      role: 'employee',
      createdAt: '2024-01-01',
      accountNumber: 1,
      email: 'john@test.com',
      isActive: true,
      seats: 1,
      planType: 'basic',
      monthlyPoints: 100,
      accountType: 'standard',
      companyName: 'TestCo',
      giftedPoints: 50,
      pointsReceived: 50,
      visible: true,
      avatar: null,
    );

FeedData _testFeedData({
  required String id,
  String header = 'Test header',
  String body = 'Test body',
  String type = 'recognition',
  DateTime? createdAt,
}) =>
    FeedData(
      id: id,
      account: 1,
      header: header,
      body: body,
      footer: null,
      sender: _testSender(),
      type: type,
      comments: [],
      likes: [],
      createdAt: createdAt ?? DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
      visible: true,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HomeViewModel viewModel;
  late MockPersonalizeFeedUseCase mockPersonalizeFeed;
  late MockAnalyzeSentimentUseCase mockAnalyzeSentiment;

  setUp(() {
    mockPersonalizeFeed = MockPersonalizeFeedUseCase();
    mockAnalyzeSentiment = MockAnalyzeSentimentUseCase();

    viewModel = HomeViewModel(
      MockUserUseCase(),
      MockSessionTokenHandler(),
      MockGetCompanyBannersUseCase(),
      MockGetCompanyFeedsUseCase(),
      MockCreateFeedCommentUseCase(),
      MockHandleLikesUseCase(),
      MockGetCategoriesUseCase(),
      MockGetCategoryBadgesUseCase(),
      MockGetCompanyCollaboratorsUseCase(),
      MockCreateAcknowledgmentUseCase(),
      MockGetCompanyAnnouncementsUseCase(),
      MockGetUserEmbassysUseCase(),
      MockGetRankingUseCase(),
      mockPersonalizeFeed,
      mockAnalyzeSentiment,
    );
  });

  group('Feed Personalization', () {
    test('initial state is not personalized', () {
      expect(viewModel.isPersonalized, isFalse);
      expect(viewModel.personalizingFeed, isFalse);
      expect(viewModel.feedPersonalization, isNull);
    });

    test('toggleFeedPersonalization turns off when already personalized',
        () async {
      // Set up feeds first
      viewModel.feeds = CompanyFeed(
        data: [
          _testFeedData(id: 'f1', createdAt: DateTime(2024, 1, 2)),
          _testFeedData(id: 'f2', createdAt: DateTime(2024, 1, 1)),
        ],
        success: true,
      );

      // First enable personalization
      when(() => mockPersonalizeFeed.invoke(
            userId: any(named: 'userId'),
            feedItems: any(named: 'feedItems'),
            userProfile: any(named: 'userProfile'),
          )).thenAnswer((_) async => Result.success(
            PersonalizedFeedResult(
              orderedFeedIds: ['f2', 'f1'],
              insights: {},
            ),
          ));

      await viewModel.toggleFeedPersonalization();
      expect(viewModel.isPersonalized, isTrue);

      // Now toggle off
      await viewModel.toggleFeedPersonalization();
      expect(viewModel.isPersonalized, isFalse);
      expect(viewModel.feedPersonalization, isNull);
    });

    test('toggleFeedPersonalization reorders feeds on success', () async {
      viewModel.feeds = CompanyFeed(
        data: [
          _testFeedData(id: 'f1', createdAt: DateTime(2024, 1, 2)),
          _testFeedData(id: 'f2', createdAt: DateTime(2024, 1, 1)),
        ],
        success: true,
      );

      when(() => mockPersonalizeFeed.invoke(
            userId: any(named: 'userId'),
            feedItems: any(named: 'feedItems'),
            userProfile: any(named: 'userProfile'),
          )).thenAnswer((_) async => Result.success(
            PersonalizedFeedResult(
              orderedFeedIds: ['f2', 'f1'],
              insights: {
                'f2': FeedInsight(
                    feedId: 'f2', relevanceScore: 0.95, reason: 'Top'),
              },
            ),
          ));

      await viewModel.toggleFeedPersonalization();

      expect(viewModel.isPersonalized, isTrue);
      expect(viewModel.personalizingFeed, isFalse);
      expect(viewModel.feeds.data.first.id, 'f2');
      expect(viewModel.feeds.data.last.id, 'f1');
      expect(viewModel.feedPersonalization, isNotNull);
    });

    test('toggleFeedPersonalization handles error gracefully', () async {
      viewModel.feeds = CompanyFeed(
        data: [_testFeedData(id: 'f1')],
        success: true,
      );

      when(() => mockPersonalizeFeed.invoke(
            userId: any(named: 'userId'),
            feedItems: any(named: 'feedItems'),
            userProfile: any(named: 'userProfile'),
          )).thenAnswer(
        (_) async => Result.error(Exception('Network error')),
      );

      await viewModel.toggleFeedPersonalization();

      expect(viewModel.isPersonalized, isFalse);
      expect(viewModel.personalizingFeed, isFalse);
    });

    test('toggleFeedPersonalization preserves feeds not in AI response',
        () async {
      viewModel.feeds = CompanyFeed(
        data: [
          _testFeedData(id: 'f1'),
          _testFeedData(id: 'f2'),
          _testFeedData(id: 'f3'),
        ],
        success: true,
      );

      // AI only returns 2 of 3 feeds
      when(() => mockPersonalizeFeed.invoke(
            userId: any(named: 'userId'),
            feedItems: any(named: 'feedItems'),
            userProfile: any(named: 'userProfile'),
          )).thenAnswer((_) async => Result.success(
            PersonalizedFeedResult(
              orderedFeedIds: ['f3', 'f1'],
              insights: {},
            ),
          ));

      await viewModel.toggleFeedPersonalization();

      expect(viewModel.feeds.data, hasLength(3));
      expect(viewModel.feeds.data[0].id, 'f3');
      expect(viewModel.feeds.data[1].id, 'f1');
      expect(viewModel.feeds.data[2].id, 'f2'); // appended at end
    });
  });

  group('Sentiment Analysis', () {
    test('initial state has empty cache', () {
      expect(viewModel.sentimentCache, isEmpty);
      expect(viewModel.getSentiment('any_id'), isNull);
      expect(viewModel.isAnalyzingSentiment('any_id'), isFalse);
    });

    test('analyzeFeedSentiment caches result on success', () async {
      final expectedSentiment = SentimentResult(
        sentiment: SentimentType.positive,
        confidence: 0.92,
        summary: 'Muy positivo',
      );

      when(() => mockAnalyzeSentiment.invoke(text: any(named: 'text')))
          .thenAnswer((_) async => Result.success(expectedSentiment));

      await viewModel.analyzeFeedSentiment('feed_1', 'Great job!');

      expect(viewModel.getSentiment('feed_1'), isNotNull);
      expect(
          viewModel.getSentiment('feed_1')!.sentiment, SentimentType.positive);
      expect(viewModel.getSentiment('feed_1')!.confidence, 0.92);
    });

    test('analyzeFeedSentiment skips if already cached', () async {
      final sentiment = SentimentResult(
        sentiment: SentimentType.positive,
        confidence: 0.9,
        summary: 'Positivo',
      );

      when(() => mockAnalyzeSentiment.invoke(text: any(named: 'text')))
          .thenAnswer((_) async => Result.success(sentiment));

      // First call
      await viewModel.analyzeFeedSentiment('feed_1', 'Test text');
      // Second call - should not trigger the use case again
      await viewModel.analyzeFeedSentiment('feed_1', 'Test text');

      verify(() => mockAnalyzeSentiment.invoke(text: 'Test text')).called(1);
    });

    test('analyzeFeedSentiment handles error without crashing', () async {
      when(() => mockAnalyzeSentiment.invoke(text: any(named: 'text')))
          .thenAnswer(
        (_) async => Result.error(Exception('Service unavailable')),
      );

      await viewModel.analyzeFeedSentiment('feed_1', 'Test');

      expect(viewModel.getSentiment('feed_1'), isNull);
      expect(viewModel.isAnalyzingSentiment('feed_1'), isFalse);
    });

    test('analyzeFeedSentiment sets analyzing state correctly', () async {
      when(() => mockAnalyzeSentiment.invoke(text: any(named: 'text')))
          .thenAnswer((_) async {
        // During execution, the feedId should be in _analyzingFeedIds
        return Result.success(SentimentResult(
          sentiment: SentimentType.neutral,
          confidence: 0.5,
          summary: 'Neutral',
        ));
      });

      await viewModel.analyzeFeedSentiment('feed_1', 'Test');

      // After completion, it should no longer be analyzing
      expect(viewModel.isAnalyzingSentiment('feed_1'), isFalse);
    });

    test('can analyze multiple feeds independently', () async {
      when(() => mockAnalyzeSentiment.invoke(text: 'Text A'))
          .thenAnswer((_) async => Result.success(SentimentResult(
                sentiment: SentimentType.positive,
                confidence: 0.9,
                summary: 'Positivo',
              )));

      when(() => mockAnalyzeSentiment.invoke(text: 'Text B'))
          .thenAnswer((_) async => Result.success(SentimentResult(
                sentiment: SentimentType.negative,
                confidence: 0.8,
                summary: 'Negativo',
              )));

      await viewModel.analyzeFeedSentiment('feed_a', 'Text A');
      await viewModel.analyzeFeedSentiment('feed_b', 'Text B');

      expect(
          viewModel.getSentiment('feed_a')!.sentiment, SentimentType.positive);
      expect(
          viewModel.getSentiment('feed_b')!.sentiment, SentimentType.negative);
    });
  });

  group('Company banners', () {
    late MockGetCompanyBannersUseCase bannersUseCase;

    setUp(() {
      bannersUseCase = MockGetCompanyBannersUseCase();
      viewModel = HomeViewModel(
        MockUserUseCase(),
        MockSessionTokenHandler(),
        bannersUseCase,
        MockGetCompanyFeedsUseCase(),
        MockCreateFeedCommentUseCase(),
        MockHandleLikesUseCase(),
        MockGetCategoriesUseCase(),
        MockGetCategoryBadgesUseCase(),
        MockGetCompanyCollaboratorsUseCase(),
        MockCreateAcknowledgmentUseCase(),
        MockGetCompanyAnnouncementsUseCase(),
        MockGetUserEmbassysUseCase(),
        MockGetRankingUseCase(),
        mockPersonalizeFeed,
        mockAnalyzeSentiment,
      );
    });

    test('starts loading and exposes zero banners on an empty response',
        () async {
      final response = CompanyBanners(success: true, banners: []);
      when(() => bannersUseCase.invoke())
          .thenAnswer((_) async => Result.success(response));

      final request = viewModel.getCompanyBanners();
      expect(viewModel.bannersLoading, isTrue);
      expect(viewModel.bannersError, isNull);
      await request;

      expect(viewModel.bannersLoading, isFalse);
      expect(viewModel.banners, isEmpty);
      expect(viewModel.bannersList, isEmpty);
      expect(viewModel.bannersError, isNull);
    });

    test('stores one banner and its image URI', () async {
      final banner = Banner(id: 'b1', name: 'One', image: 'https://one');
      when(() => bannersUseCase.invoke())
          .thenAnswer((_) async => Result.success(
                CompanyBanners(success: true, banners: [banner]),
              ));

      await viewModel.getCompanyBanners();

      expect(viewModel.banners, hasLength(1));
      expect(viewModel.banners.single.id, 'b1');
      expect(viewModel.bannersList, ['https://one']);
    });

    test(
        'stores many banners and excludes banners without images from URI list',
        () async {
      when(() => bannersUseCase.invoke())
          .thenAnswer((_) async => Result.success(
                CompanyBanners(success: true, banners: [
                  Banner(id: 'b1', image: 'https://one'),
                  Banner(id: 'b2'),
                  Banner(id: 'b3', image: 'https://three'),
                ]),
              ));

      await viewModel.getCompanyBanners();

      expect(viewModel.banners, hasLength(3));
      expect(viewModel.bannersList, ['https://one', 'https://three']);
    });

    test('exposes errors and clears loading', () async {
      final error = Exception('banner request failed');
      when(() => bannersUseCase.invoke())
          .thenAnswer((_) async => Result.error(error));

      await viewModel.getCompanyBanners();

      expect(viewModel.bannersLoading, isFalse);
      expect(viewModel.bannersError, same(error));
    });

    test('refresh replaces the previous banners', () async {
      when(() => bannersUseCase.invoke())
          .thenAnswer((_) async => Result.success(
                CompanyBanners(success: true, banners: [
                  Banner(id: 'old', image: 'https://old'),
                ]),
              ));
      await viewModel.getCompanyBanners();

      when(() => bannersUseCase.invoke())
          .thenAnswer((_) async => Result.success(
                CompanyBanners(success: true, banners: [
                  Banner(id: 'new', image: 'https://new'),
                ]),
              ));
      await viewModel.getCompanyBanners();

      expect(viewModel.banners.single.id, 'new');
      expect(viewModel.bannersList, ['https://new']);
    });
  });
}
