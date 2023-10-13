import 'package:floor/floor.dart';

@entity
class UpgradeEntity {
  @primaryKey
  int employeeNumber = 1;
  int? result;
  String? badge;

  UpgradeEntity({
    required this.employeeNumber,
    this.result,
    this.badge,
  });
}