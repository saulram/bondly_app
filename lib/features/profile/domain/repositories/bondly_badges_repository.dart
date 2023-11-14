import 'package:bondly_app/features/profile/domain/models/bondly_badges_model.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class BondlyBadgesRepository {
  BondlyBadgesRepository();

  Future<Result<BondlyBadges, Exception>> getBondlyBadges();
}
