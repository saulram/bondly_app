import 'package:bondly_app/features/auth/domain/models/upgrade_model.dart';
import 'package:bondly_app/features/storage/data/local/entities/upgrade_entity.dart';

class UpgradeEntityMapper {
  Upgrade? map(UpgradeEntity? from) {
    if (from == null) {
      return null;
    }

    return Upgrade(
      result: from.result,
      badge: from.badge
    );
  }

  UpgradeEntity mapReverse(Upgrade from, int employeeId) {
    return UpgradeEntity(
      employeeNumber: employeeId,
      result: from.result,
      badge: from.badge,
    );
  }
}
