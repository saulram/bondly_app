import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/cart_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class BulkAddCartItemsUseCase {
  final CartRepository _repository;

  BulkAddCartItemsUseCase(this._repository);

  Future<Result<UserCart, Exception>> invoke(
      Map<String, dynamic> items, String cartId) async {
    return _repository.bulkAddCartItems(items, cartId);
  }
}
