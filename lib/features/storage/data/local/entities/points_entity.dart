import 'package:floor/floor.dart';

@entity
class PointsEntity {
  @primaryKey
  int employeeId = 1;
  int? current;
  int? temporal;

  PointsEntity({
    required this.employeeId,
    this.current,
    this.temporal,
  });
}