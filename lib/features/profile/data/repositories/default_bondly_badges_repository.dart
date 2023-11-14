import 'package:bondly_app/features/profile/data/api/bondly_badges_api.dart';
import 'package:bondly_app/features/profile/domain/models/bondly_badges_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/bondly_badges_repository.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

class DefaultBondlyBadgesRepository extends BondlyBadgesRepository {
  final BondlyBadgesAPI _api;
  final Logger log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  DefaultBondlyBadgesRepository(this._api);

  @override
  Future<Result<BondlyBadges, Exception>> getBondlyBadges() async {
    try {
      var result = await _api.getBondlyBadges();
      return Result.success(result);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }
}
