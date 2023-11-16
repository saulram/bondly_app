import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/cart_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class PushCartItemUseCase {
  final CartRepository _repository;

  PushCartItemUseCase(this._repository);

  Future<Result<UserCart, Exception>> invoke(
      String cartId, String itemId) async {
    return _repository.pushCartItem(cartId, itemId);
  }
}
