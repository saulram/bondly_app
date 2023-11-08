import 'package:bondly_app/features/profile/data/api/cart_api.dart';
import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/domain/models/rewards_list_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/cart_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class DefaultCartRepository extends CartRepository {
  final CartAPI _cartAPI;

  DefaultCartRepository(this._cartAPI);

  @override
  Future<Result<UserCart, Exception>> bulkAddCartItems(
      Map<String, dynamic> items, String cartId) async {
    try {
      var result = await _cartAPI.bulkAddCartItems(items, cartId);
      return Result.success(result);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<bool, Exception>> checkOutCart(String cartId) async {
    try {
      var result = await _cartAPI.checkOutCart(cartId);
      return Result.success(result);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<UserCart, Exception>> clearShoppingCart(String cartId) async {
    try {
      var result = await _cartAPI.clearShoppingCart(cartId);
      return Result.success(result);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<RewardList, Exception>> getShoppingItems() async {
    try {
      var result = await _cartAPI.getShoppingItems();
      return Result.success(result);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<UserCart, Exception>> getUserShoppingCart() async {
    try {
      var result = await _cartAPI.getUserShoppingCart();
      return Result.success(result);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<UserCart, Exception>> pullCartItem(
      String cartId, String itemId) async {
    try {
      var result = await _cartAPI.pullCartItem(cartId, itemId);
      return Result.success(result);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<UserCart, Exception>> pushCartItem(
      String cartId, String itemId) async {
    try {
      var result = await _cartAPI.pushCartItem(cartId, itemId);
      return Result.success(result);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }
}
