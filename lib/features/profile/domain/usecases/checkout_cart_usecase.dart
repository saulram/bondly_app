import 'package:bondly_app/features/profile/domain/repositories/cart_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class CheckOutCartUseCase {
  final CartRepository _repository;

  CheckOutCartUseCase(this._repository);

  Future<Result<bool, Exception>> invoke(String cartId) async {
    return _repository.checkOutCart(cartId);
  }
}
