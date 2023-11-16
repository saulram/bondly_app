import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/domain/models/rewards_list_model.dart';
import 'package:multiple_result/multiple_result.dart';

class NoConnectionException implements Exception {}

class UnauthorizedException implements Exception {}

class NotFoundException implements Exception {}

class BadRequestException implements Exception {}

abstract class CartRepository {
  Future<Result<RewardList, Exception>> getShoppingItems();

  Future<Result<UserCart, Exception>> getUserShoppingCart();

  Future<Result<UserCart, Exception>> bulkAddCartItems(
      Map<String, dynamic> items, String cartId);

  Future<Result<UserCart, Exception>> pushCartItem(
      String cartId, String itemId);

  Future<Result<UserCart, Exception>> pullCartItem(
      String cartId, String itemId);

  Future<Result<UserCart, Exception>> clearShoppingCart(String cartId);

  Future<Result<bool, Exception>> checkOutCart(String cartId);
}
