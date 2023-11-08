import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/cart_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetUserShoppingCartUseCase {
  final CartRepository _repository;

  GetUserShoppingCartUseCase(this._repository);

  Future<Result<UserCart, Exception>> invoke() async {
    return _repository.getUserShoppingCart();
  }
}
