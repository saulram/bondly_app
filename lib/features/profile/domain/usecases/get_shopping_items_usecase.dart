import 'package:bondly_app/features/profile/domain/models/rewards_list_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/cart_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetShoppingItemsUseCase {
  final CartRepository _repository;

  GetShoppingItemsUseCase(this._repository);

  Future<Result<RewardList, Exception>> invoke() async {
    return _repository.getShoppingItems();
  }
}
