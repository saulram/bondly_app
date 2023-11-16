import 'package:bondly_app/features/profile/domain/models/bondly_badges_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/bondly_badges_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetBondlyBadgesUseCase {
  final BondlyBadgesRepository _repository;

  GetBondlyBadgesUseCase(this._repository);

  Future<Result<BondlyBadges, Exception>> invoke() async {
    return _repository.getBondlyBadges();
  }
}
