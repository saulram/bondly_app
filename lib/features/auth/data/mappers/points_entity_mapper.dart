import 'package:bondly_app/features/auth/domain/models/points_model.dart';
import 'package:bondly_app/features/storage/data/local/entities/points_entity.dart';

class PointsEntityMapper {

  Points? map(PointsEntity? from) {
    if (from == null) {
      return null;
    }

    return Points(
        current: from.current,
        temporal: from.temporal
    );
  }

  PointsEntity mapReverse(Points from, int employeeId) {
    return PointsEntity(
      employeeId: employeeId,
      current: from.current,
      temporal: from.temporal
    );
  }
}