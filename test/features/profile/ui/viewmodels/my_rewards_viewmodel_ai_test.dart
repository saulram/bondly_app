import 'package:bondly_app/features/ai/domain/models/reward_recommendation.dart';
import 'package:bondly_app/features/ai/domain/usecases/get_reward_recommendations_usecase.dart';
import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/domain/models/rewards_list_model.dart';
import 'package:bondly_app/features/profile/domain/usecases/bulk_add_cart_items_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/checkout_cart_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_shopping_cart_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_shopping_items_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/pull_cart_item.usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/push_cart_item.usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_account_statement_usecase.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/my_rewards_viewmodel.dart';
import 'package:bondly_app/src/app_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockGetShoppingItemsUseCase extends Mock
    implements GetShoppingItemsUseCase {}

class MockBulkAddCartItemsUseCase extends Mock
    implements BulkAddCartItemsUseCase {}

class MockGetUserShoppingCartUseCase extends Mock
    implements GetUserShoppingCartUseCase {}

class MockPushCartItemUseCase extends Mock implements PushCartItemUseCase {}

class MockPullCartItemUseCase extends Mock implements PullCartItemUseCase {}

class MockCheckOutCartUseCase extends Mock implements CheckOutCartUseCase {}

class MockAppServices extends Mock implements AppServices {}

class MockGetRewardRecommendationsUseCase extends Mock
    implements GetRewardRecommendationsUseCase {}

class MockGetAccountStatementUseCase extends Mock
    implements GetAccountStatementUseCase {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

Reward _testReward({
  required String id,
  String name = 'Test Reward',
  int points = 100,
}) =>
    Reward(
      id: id,
      name: name,
      description: 'A test reward',
      category: 'gifts',
      points: points,
      image: 'image.png',
      deadline: null,
      companyName: 'TestCo',
      enable: true,
      visible: true,
      likes: [],
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MyRewardsViewModel viewModel;
  late MockGetShoppingItemsUseCase mockGetShoppingItems;
  late MockGetUserShoppingCartUseCase mockGetUserCart;
  late MockGetRewardRecommendationsUseCase mockGetRecommendations;
  late MockGetAccountStatementUseCase mockGetAccountStatement;

  setUp(() {
    mockGetShoppingItems = MockGetShoppingItemsUseCase();
    mockGetUserCart = MockGetUserShoppingCartUseCase();
    mockGetRecommendations = MockGetRewardRecommendationsUseCase();
    mockGetAccountStatement = MockGetAccountStatementUseCase();

    // Stub init() calls to prevent errors during construction
    when(() => mockGetShoppingItems.invoke()).thenAnswer(
      (_) async => Result.success(RewardList(rewards: [])),
    );
    when(() => mockGetUserCart.invoke()).thenAnswer(
      (_) async => Result.success(UserCart(rewards: [])),
    );
    when(() => mockGetAccountStatement.invoke()).thenAnswer(
      (_) async =>
          Result.error(Exception('Balance is not needed in this test')),
    );

    viewModel = MyRewardsViewModel(
      mockGetShoppingItems,
      MockBulkAddCartItemsUseCase(),
      mockGetUserCart,
      MockPushCartItemUseCase(),
      MockPullCartItemUseCase(),
      MockCheckOutCartUseCase(),
      MockAppServices(),
      mockGetRecommendations,
      mockGetAccountStatement,
      MockSharedPreferences(),
    );
  });

  group('AI Reward Recommendations', () {
    test('initial state has empty recommendations', () {
      expect(viewModel.recommendations, isEmpty);
      expect(viewModel.loadingRecommendations, isFalse);
      expect(viewModel.recommendationsError, isNull);
    });

    test('handleGetRecommendations returns when rewards list is empty',
        () async {
      // rewardList is initially empty
      await viewModel.handleGetRecommendations();

      verifyNever(() => mockGetRecommendations.invoke(
            userProfile: any(named: 'userProfile'),
            availableRewards: any(named: 'availableRewards'),
          ));
    });

    test('handleGetRecommendations fetches and stores recommendations',
        () async {
      // Set up rewards first
      viewModel.rewardList = RewardList(rewards: [
        _testReward(id: 'r1', name: 'Gift Card', points: 200),
        _testReward(id: 'r2', name: 'Headphones', points: 400),
      ]);

      final expectedRecommendations = [
        RewardRecommendation(
          rewardId: 'r1',
          reason: 'Ideal para ti',
          matchScore: 0.95,
        ),
      ];

      when(() => mockGetRecommendations.invoke(
            userProfile: any(named: 'userProfile'),
            availableRewards: any(named: 'availableRewards'),
          )).thenAnswer((_) async => Result.success(expectedRecommendations));

      await viewModel.handleGetRecommendations();

      expect(viewModel.recommendations, hasLength(1));
      expect(viewModel.recommendations.first.rewardId, 'r1');
      expect(viewModel.recommendations.first.matchScore, 0.95);
      expect(viewModel.loadingRecommendations, isFalse);
    });

    test('handleGetRecommendations handles error gracefully', () async {
      viewModel.rewardList = RewardList(rewards: [
        _testReward(id: 'r1'),
      ]);

      when(() => mockGetRecommendations.invoke(
            userProfile: any(named: 'userProfile'),
            availableRewards: any(named: 'availableRewards'),
          )).thenAnswer(
        (_) async => Result.error(Exception('Network error')),
      );

      await viewModel.handleGetRecommendations();

      expect(viewModel.recommendations, isEmpty);
      expect(viewModel.loadingRecommendations, isFalse);
      expect(viewModel.recommendationsError, isNotNull);
    });

    test('handleGetRecommendations uses userProfileForAI when set', () async {
      viewModel.rewardList = RewardList(rewards: [
        _testReward(id: 'r1'),
      ]);
      viewModel.userProfileForAI = {
        'name': 'Custom User',
        'availablePoints': 999,
        'monthlyPoints': 200,
        'company': 'CustomCo',
      };

      when(() => mockGetRecommendations.invoke(
            userProfile: any(named: 'userProfile'),
            availableRewards: any(named: 'availableRewards'),
          )).thenAnswer((_) async => Result.success([]));

      await viewModel.handleGetRecommendations();

      final captured = verify(() => mockGetRecommendations.invoke(
            userProfile: captureAny(named: 'userProfile'),
            availableRewards: any(named: 'availableRewards'),
          )).captured;

      final profile = captured.first as Map<String, dynamic>;
      expect(profile['name'], 'Custom User');
      expect(profile['availablePoints'], 999);
      expect(profile['company'], 'CustomCo');
    });

    test(
        'handleGetRecommendations uses default profile when userProfileForAI is null',
        () async {
      viewModel.rewardList = RewardList(rewards: [
        _testReward(id: 'r1'),
      ]);
      viewModel.userProfileForAI = null;

      when(() => mockGetRecommendations.invoke(
            userProfile: any(named: 'userProfile'),
            availableRewards: any(named: 'availableRewards'),
          )).thenAnswer((_) async => Result.success([]));

      await viewModel.handleGetRecommendations();

      final captured = verify(() => mockGetRecommendations.invoke(
            userProfile: captureAny(named: 'userProfile'),
            availableRewards: any(named: 'availableRewards'),
          )).captured;

      final profile = captured.first as Map<String, dynamic>;
      expect(profile['name'], 'Usuario');
      expect(profile['availablePoints'], 0);
    });

    test('getRewardById returns reward when found', () {
      viewModel.rewardList = RewardList(rewards: [
        _testReward(id: 'r1', name: 'Gift Card'),
        _testReward(id: 'r2', name: 'Headphones'),
      ]);

      final reward = viewModel.getRewardById('r1');
      expect(reward, isNotNull);
      expect(reward!.name, 'Gift Card');
    });

    test('getRewardById returns null when not found', () {
      viewModel.rewardList = RewardList(rewards: [
        _testReward(id: 'r1'),
      ]);

      final reward = viewModel.getRewardById('nonexistent');
      expect(reward, isNull);
    });

    test('getRewardById returns null on empty list', () {
      viewModel.rewardList = RewardList(rewards: []);

      final reward = viewModel.getRewardById('r1');
      expect(reward, isNull);
    });

    test('handleGetRecommendations sends reward data in correct format',
        () async {
      viewModel.rewardList = RewardList(rewards: [
        _testReward(id: 'r1', name: 'Gift Card', points: 200),
      ]);

      when(() => mockGetRecommendations.invoke(
            userProfile: any(named: 'userProfile'),
            availableRewards: any(named: 'availableRewards'),
          )).thenAnswer((_) async => Result.success([]));

      await viewModel.handleGetRecommendations();

      final captured = verify(() => mockGetRecommendations.invoke(
            userProfile: any(named: 'userProfile'),
            availableRewards: captureAny(named: 'availableRewards'),
          )).captured;

      final rewards = captured.first as List<Map<String, dynamic>>;
      expect(rewards, hasLength(1));
      expect(rewards.first['id'], 'r1');
      expect(rewards.first['name'], 'Gift Card');
      expect(rewards.first['points'], 200);
    });
  });
}
