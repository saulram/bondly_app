import 'dart:convert';

import 'package:bondly_app/config/strings_cart.dart';
import 'package:bondly_app/features/ai/domain/models/reward_recommendation.dart';
import 'package:bondly_app/features/ai/domain/usecases/get_reward_recommendations_usecase.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/screens/home_screen.dart';
import 'package:bondly_app/features/profile/domain/models/account_statement_model.dart';
import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/domain/models/rewards_list_model.dart';
import 'package:bondly_app/features/profile/domain/usecases/bulk_add_cart_items_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/checkout_cart_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_account_statement_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_shopping_cart_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_shopping_items_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/pull_cart_item.usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/push_cart_item.usecase.dart';
import 'package:bondly_app/src/app_services.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRewardsViewModel extends NavigationModel {
  Logger log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );
  final GetShoppingItemsUseCase _getShoppingItemsUseCase;
  final BulkAddCartItemsUseCase _bulkAddCartItemsUseCase;
  final GetUserShoppingCartUseCase _getUserShoppingCartUseCase;
  final PushCartItemUseCase _pushCartItemUseCase;
  final PullCartItemUseCase _pullCartItemUseCase;
  final CheckOutCartUseCase _checkOutCartUseCase;
  final GetRewardRecommendationsUseCase _getRewardRecommendationsUseCase;
  final GetAccountStatementUseCase _getAccountStatementUseCase;
  final SharedPreferences _sharedPreferences;

  final GlobalKey<ScaffoldState> cartScaffoldKey = GlobalKey<ScaffoldState>();
  final AppServices snackBarService;

  static const String _cartStorageKey = 'local_cart_items';

  MyRewardsViewModel(
      this._getShoppingItemsUseCase,
      this._bulkAddCartItemsUseCase,
      this._getUserShoppingCartUseCase,
      this._pushCartItemUseCase,
      this._pullCartItemUseCase,
      this._checkOutCartUseCase,
      this.snackBarService,
      this._getRewardRecommendationsUseCase,
      this._getAccountStatementUseCase,
      this._sharedPreferences) {
    log.i("MyRewardsViewModel Created");
    init();
  }

  Future<void> init() async {
    _loadCartFromLocal();
    await Future.wait([
      handleGetUserCart(),
      handleGetRewards(),
      handleGetBalance(),
    ]);
  }

  // ── Balance state ──────────────────────────────────────────────────

  int? _userBalance;
  int? get userBalance => _userBalance;

  Future<void> handleGetBalance() async {
    Result<AccountStatement, Exception> result =
        await _getAccountStatementUseCase.invoke();
    result.when((statement) {
      _userBalance = statement.balance;
      log.i("### User balance fetched: $_userBalance");
      notifyListeners();
    }, (error) {
      log.e("### Error fetching user balance: $error");
    });
  }

  // ── Reward points map ──────────────────────────────────────────────

  final Map<String, int> _rewardPointsMap = {};

  // ── Cart total ─────────────────────────────────────────────────────

  int get cartTotal {
    int total = 0;
    for (var item in _cartItems) {
      if (item == null) continue;
      final id = item['id'] as String?;
      final qty = item['quantity'] as int? ?? 0;
      if (id != null && _rewardPointsMap.containsKey(id)) {
        total += _rewardPointsMap[id]! * qty;
      }
    }
    return total;
  }

  // ── Affordability check ────────────────────────────────────────────

  bool canAffordItem(String itemId) {
    if (_userBalance == null) return true; // Allow if balance unknown
    final itemPoints = _rewardPointsMap[itemId] ?? 0;
    return cartTotal + itemPoints <= _userBalance!;
  }

  // ── Rewards list ───────────────────────────────────────────────────

  RewardList _rewardList = RewardList(rewards: []);

  RewardList get rewardList => _rewardList;

  set rewardList(RewardList rewardList) {
    _rewardList = rewardList;
    notifyListeners();
  }

  List<Map<String, dynamic>?> _cartItems = [];

  List<Map<String, dynamic>?> get cartItems => _cartItems;

  set cartIems(List<Map<String, dynamic>?> items) {
    _cartItems = items;
    notifyListeners();
  }

  Future<void> filterByCategory(String category) async {
    busy = true;
    await handleGetRewards();
    if (category == StringsCart.categoryAll) {
      rewardList = RewardList(rewards: _rewardList.rewards);
    } else {
      List<Reward> filteredList = [];
      for (var reward in _rewardList.rewards ?? []) {
        if (reward.category == category) {
          filteredList.add(reward);
        }
      }
      rewardList = RewardList(rewards: filteredList);
      busy = false;
    }
    busy = false;
  }

  bool _cartEdited = false;
  bool get cartEdited => _cartEdited;
  set cartEdited(bool state) {
    _cartEdited = state;
    notifyListeners();
  }

  bool addToCart(String itemId, {int? quantity, bool skipValidation = false}) {
    if (!skipValidation && !canAffordItem(itemId)) {
      return false;
    }

    // Busca si el elemento ya está en el carrito
    final existingItem = _cartItems.firstWhere(
      (item) => item!['id'] == itemId,
      orElse: () => null,
    );

    if (existingItem != null) {
      // Incrementa la cantidad si el elemento ya está en el carrito
      existingItem['quantity'] = (existingItem['quantity'] ?? 0) + 1;
    } else {
      // Agrega un nuevo elemento al carrito
      log.i("Adding Item: $itemId");
      _cartItems.add({'id': itemId, 'quantity': quantity ?? 1});
    }

    _saveCartToLocal();
    notifyListeners();
    return true;
  }

  void removeFromCart(String itemId) {
    // Busca el elemento en el carrito
    final existingItem = _cartItems.firstWhere(
      (item) => item!['id'] == itemId,
      orElse: () => null,
    );

    if (existingItem != null) {
      final currentQuantity = existingItem['quantity'] ?? 0;

      if (currentQuantity > 1) {
        // Decrementa la cantidad si es mayor que 1
        existingItem['quantity'] = currentQuantity - 1;
      } else {
        // Elimina el elemento del carrito si la cantidad es 1
        _cartItems.remove(existingItem);
      }

      _saveCartToLocal();
      notifyListeners();
    }
  }

  int getItemCount(String itemId) {
    final item = _cartItems.firstWhere(
      (cartItem) => cartItem!['id'] == itemId,
      orElse: () => null,
    );

    return item != null ? item['quantity'] : 0;
  }

  Future<void> handleGetRewards() async {
    Result result = await _getShoppingItemsUseCase.invoke();
    result.when((rewards) {
      rewardList = rewards;

      _rewardPointsMap.clear();
      for (var reward in (rewards as RewardList).rewards ?? []) {
        _rewardPointsMap[reward.id] = reward.points;
      }
    }, (error) {
      log.e(error);
    });
  }

  UserCart _userCart = UserCart(
    rewards: [],
  );
  UserCart get userCart => _userCart;

  set userCart(UserCart cart) {
    _userCart = cart;
    notifyListeners();
  }

  Future<UserCart> handleGetUserCart() async {
    Result result = await _getUserShoppingCartUseCase.invoke();
    result.when((cart) {
      UserCart myCart = cart;

      _cartItems = [];
      for (var originalElement in myCart.rewards) {
        log.i("Cart Item: ${originalElement.quantity.toString()}");
        addToCart(originalElement.reward.id,
            quantity: originalElement.quantity, skipValidation: true);
      }
      log.i("User Cart: ${cart.id.toString()}");
      userCart = myCart;
      _saveCartToLocal();
    }, (error) {
      log.e(error);
    });
    return userCart;
  }

  bool _updatingCart = false;
  bool get updatingCart => _updatingCart;
  set updatingCart(bool updatingCart) {
    _updatingCart = updatingCart;
    notifyListeners();
  }

  Future<UserCart> sendItemsToCart() async {
    Map<String, dynamic> body = {"rewards": _cartItems};
    log.i(body);
    log.i("User Cart Id: ${_userCart.id}");

    Result result = await _bulkAddCartItemsUseCase.invoke(body, _userCart.id);
    result.when((cart) {
      userCart = cart;
      _saveCartToLocal();
    }, (error) {
      log.e(error);
    });
    return userCart;
  }

  Future<UserCart> pushItem(String rewardId) async {
    updatingCart = true;
    Result result = await _pushCartItemUseCase.invoke(_userCart.id, rewardId);
    result.when((cart) {
      userCart = cart;
    }, (error) {
      log.e(error);
    });
    updatingCart = false;
    return userCart;
  }

  List<String> _rewardCategories = [
    StringsCart.categoryAll,
    StringsCart.categoryExperiences,
    StringsCart.categoryGiftCards,
    StringsCart.categoryIncentives,
  ];
  List<String> get rewardCategories => _rewardCategories;
  set rewardCategories(List<String> categories) {
    _rewardCategories = categories;
    notifyListeners();
  }

  Future<UserCart> pullItem(String rewardId) async {
    updatingCart = true;
    Result result = await _pullCartItemUseCase.invoke(_userCart.id, rewardId);
    result.when((cart) {
      userCart = cart;
    }, (error) {
      log.e(error);
    });
    updatingCart = false;
    return userCart;
  }

  Future<bool> checkOutCart() async {
    navigation.pop();
    busy = true;
    Result result = await _checkOutCartUseCase.invoke(_userCart.id);
    busy = false;
    bool success = false;
    result.when((_) {
      _clearLocalCart();
      navigation.go(HomeScreen.route);
      handleShowSnackBar(StringsCart.checkoutSuccess);
      success = true;
    }, (error) {
      log.e(error);
      handleShowSnackBar(StringsCart.checkoutError);
    });
    return success;
  }

  void handleResetAll() {
    _cartItems = [];
    _userCart = UserCart(rewards: []);
    _clearLocalCart();
    notifyListeners();
  }

  void handleShowSnackBar(String message) {
    snackBarService.showSnackbar(cartScaffoldKey, message);
  }

  // ── Local cart persistence ─────────────────────────────────────────

  Future<void> _saveCartToLocal() async {
    try {
      final encoded = jsonEncode(_cartItems);
      await _sharedPreferences.setString(_cartStorageKey, encoded);
    } catch (e) {
      log.e("Failed to save cart locally: $e");
    }
  }

  void _loadCartFromLocal() {
    final stored = _sharedPreferences.getString(_cartStorageKey);
    if (stored != null) {
      try {
        final decoded = jsonDecode(stored) as List<dynamic>;
        _cartItems = decoded.map((e) => e as Map<String, dynamic>?).toList();
        notifyListeners();
      } catch (e) {
        log.e("Corrupted local cart data, clearing: $e");
        _clearLocalCart();
      }
    }
  }

  Future<void> _clearLocalCart() async {
    try {
      await _sharedPreferences.remove(_cartStorageKey);
    } catch (e) {
      log.e("Failed to clear local cart: $e");
    }
  }

  @override
  void dispose() {
    log.i("MyRewardsViewModel Disposed");
    super.dispose();
  }

  // ================================
  // AI: Reward Recommendations
  // ================================

  List<RewardRecommendation> _recommendations = [];
  List<RewardRecommendation> get recommendations => _recommendations;

  bool _loadingRecommendations = false;
  bool get loadingRecommendations => _loadingRecommendations;

  /// User profile data set externally before fetching recommendations.
  Map<String, dynamic>? userProfileForAI;

  Future<void> handleGetRecommendations() async {
    if (_rewardList.rewards == null || _rewardList.rewards!.isEmpty) return;

    _loadingRecommendations = true;
    notifyListeners();

    final availableRewards = _rewardList.rewards!.map((r) {
      return {
        'id': r.id,
        'name': r.name,
        'description': r.description,
        'points': r.points,
        'category': r.category,
        'likesCount': r.likes.length,
      };
    }).toList();

    final userProfile = userProfileForAI ?? {
      'name': 'Usuario',
      'availablePoints': 0,
      'monthlyPoints': 0,
      'company': '',
    };

    final result = await _getRewardRecommendationsUseCase.invoke(
      userProfile: userProfile,
      availableRewards: availableRewards,
    );

    result.when((recs) {
      _recommendations = recs;
      log.i("MyRewardsViewModel### Recommendations: ${recs.length}");
    }, (error) {
      log.e("Recommendations error: $error");
    });

    _loadingRecommendations = false;
    notifyListeners();
  }

  Reward? getRewardById(String id) {
    try {
      return _rewardList.rewards?.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
