import 'package:bondly_app/features/storage/data/local/entities/upgrade_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class UpgradeDao {
  @Query('SELECT * FROM UpgradeEntity')
  Future<List<UpgradeEntity>> getUserUpgrade();

  @Query('SELECT * FROM UpgradeEntity WHERE employeeNumber = :id')
  Future<UpgradeEntity?> getUserUpgradeById(int id);

  @insert
  Future<void> saveUserUpgrade(UpgradeEntity upgrade);
}