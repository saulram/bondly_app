import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/screens/home_screen.dart';
import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/domain/models/rewards_list_model.dart';
import 'package:bondly_app/features/profile/domain/usecases/bulk_add_cart_items_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/checkout_cart_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_shopping_cart_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_shopping_items_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/pull_cart_item.usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/push_cart_item.usecase.dart';
import 'package:bondly_app/src/app_services.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

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

  final GlobalKey<ScaffoldState> cartScaffoldKey = GlobalKey<ScaffoldState>();
  final AppServices snackBarService;

  MyRewardsViewModel(
      this._getShoppingItemsUseCase,
      this._bulkAddCartItemsUseCase,
      this._getUserShoppingCartUseCase,
      this._pushCartItemUseCase,
      this._pullCartItemUseCase,
      this._checkOutCartUseCase,
      this.snackBarService) {
    log.i("MyRewardsViewModel Created");
    init();
  }

  Future<void> init() async {
    Future.wait([
      handleGetUserCart(),
      handleGetRewards(),
    ]);
  }

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
    if (category == "Todos") {
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

  void addToCart(String itemId, {int? quantity}) {
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

    notifyListeners();
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

      for (var originalElement in myCart.rewards) {
        log.i("Cart Item: ${originalElement.quantity.toString()}");
        addToCart(originalElement.reward.id,
            quantity: originalElement.quantity);
      }
      log.i("User Cart: ${cart.id.toString()}");
      userCart = myCart;
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
    "Todos",
    "Experiencias",
    "Gift Cards",
    "Incentivos"
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
    result.when((success) {
      navigation.go(HomeScreen.route);
      handleShowSnackBar(
          "¡Felicidades! Has canjeado tus puntos exitosamente! 🎉 El departamento de RR.HH. Se pondrá en contacto contigo.");
      return true;
    }, (error) {
      log.e(error);
      handleShowSnackBar(
          "¡Lo sentimos! No se pudo procesar tu solicitud. Por favor intenta de nuevo.");
      return false;
    });
    return true;
  }

  void handleResetAll() {
    _cartItems = [];
    _userCart = UserCart(rewards: []);
    notifyListeners();
  }

  void handleShowSnackBar(String message) {
    snackBarService.showSnackbar(cartScaffoldKey, message);
  }

  @override
  void dispose() {
    log.i("MyRewardsViewModel Disposed");
    super.dispose();
  }
}
