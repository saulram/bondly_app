import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/cart_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class ClearShoppingCartUseCase {
  final CartRepository _repository;

  ClearShoppingCartUseCase(this._repository);

  Future<Result<UserCart, Exception>> invoke(String cartId) async {
    return _repository.clearShoppingCart(cartId);
  }
}
