import 'dart:convert';

import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/domain/models/rewards_list_model.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class CartAPI {
  final ApiCallsHandler _callsHandler;
  final Logger log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  CartAPI(
    this._callsHandler,
  );

  /// Retrieves a list of shopping items from the API.
  /// Returns a [RewardList] object.
  Future<RewardList> getShoppingItems() async {
    try {
      Response response = await _callsHandler.get(path: "reward/");
      log.i("### GetShoppingItems Response: ${response.statusCode}");
      return RewardList.fromJson(json.decode(response.body));
    } catch (exception) {
      log.e("### GetShoppingItems Exception: $exception");
      throw NoConnectionException();
    }
  }

  /// Retrieves the user's shopping cart from the API.
  /// Returns a [UserCart] object.
  Future<UserCart> getUserShoppingCart() async {
    try {
      var response = await _callsHandler.get(path: "cart/user/");
      log.i("### GetUserShoppingCart Response: ${response.statusCode}");
      log.i("### GetUserShoppingCart Response: ${response.body}");
      return UserCart.fromJson(json.decode(response.body)["data"]);
    } catch (exception) {
      log.e("### GetUserShoppingCart Exception: $exception");
      throw NoConnectionException();
    }
  }

  /// Adds a new item to the user's shopping cart and returns the updated cart
  ///
  /// Throws [NoConnectionException] if there is no internet connection
  /// Throws [UnauthorizedException] if the user is not logged in
  /// Throws [NotFoundException] if the item is not found
  /// Throws [BadRequestException] if the item is already in the cart
  ///
  /// Example of body:
  /// {
  ///   "rewards":[
  ///     {
  ///       "id":  "64f107d476f0bc2ec94c2f63",
  ///       "quantity":1
  ///     }
  ///   ]
  /// }
  ///
  /// [items] is a map of items to be added to the cart
  /// [cartId] is the ID of the user's cart
  ///
  /// Returns a [UserCart] object representing the updated cart
  Future<UserCart> bulkAddCartItems(
      Map<String, dynamic> items, String cartId) async {
    try {
      var response =
          await _callsHandler.put(path: "cart/$cartId/bulkAdd", data: items);
      log.i("### BulkAddCartItems Response: ${response.statusCode}");
      return UserCart.fromJson(json.decode(response.body)["data"]);
    } catch (exception) {
      log.e("### BulkAddCartItems Exception: $exception");
      throw NoConnectionException();
    }
  }

  /// Pushes an item to the user's shopping cart.
  ///
  /// Returns a [UserCart] object representing the updated shopping cart.
  /// Throws a [NoConnectionException] if there is no internet connection.
  Future<UserCart> pushCartItem(
    String cartId,
    String itemId,
  ) async {
    try {
      var response = await _callsHandler.put(path: "cart/$cartId/push/$itemId");
      log.i("### PushCartItem Response: ${response.statusCode}");
      return UserCart.fromJson(json.decode(response.body)["data"]);
    } catch (exception) {
      log.e("### PushCartItem Exception: $exception");
      throw NoConnectionException();
    }
  }

  /// Removes an item from the user's shopping cart.
  ///
  /// Returns a [UserCart] object representing the updated shopping cart.
  /// Throws a [NoConnectionException] if there is no internet connection.
  Future<UserCart> pullCartItem(
    String cartId,
    String itemId,
  ) async {
    try {
      var response = await _callsHandler.put(path: "cart/$cartId/pull/$itemId");
      log.i("### PullCartItem Response: ${response.statusCode}");
      return UserCart.fromJson(json.decode(response.body)["data"]);
    } catch (exception) {
      log.e("### PullCartItem Exception: $exception");
      throw NoConnectionException();
    }
  }

  /// Clears the user's shopping cart.
  ///
  /// Returns a [UserCart] object representing the updated shopping cart.
  /// Throws a [NoConnectionException] if there is no internet connection.
  Future<UserCart> clearShoppingCart(String cartId) async {
    try {
      var response = await _callsHandler.delete(path: "cart/user/$cartId");
      log.i("### ClearShoppingCart Response: ${response.statusCode}");
      return UserCart.fromJson(json.decode(response.body)["data"]);
    } catch (exception) {
      log.e("### ClearShoppingCart Exception: $exception");
      throw NoConnectionException();
    }
  }

  /// Checks out the user's shopping cart.
  ///
  /// Returns a boolean indicating whether the checkout was successful.
  /// Throws a [NoConnectionException] if there is no internet connection.
  Future<bool> checkOutCart(String cartId) async {
    try {
      var response = await _callsHandler.post(path: "cart/checkOut/$cartId");
      log.i("### CheckOutCart Response: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (exception) {
      log.e("### CheckOutCart Exception: $exception");
      throw NoConnectionException();
    }
  }
}
