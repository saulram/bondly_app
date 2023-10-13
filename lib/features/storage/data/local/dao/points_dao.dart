import 'package:bondly_app/features/storage/data/local/entities/points_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class PointsDao {
  @Query('SELECT * FROM PointsEntity')
  Future<List<PointsEntity>> getUserPoints();

  @Query('SELECT * FROM PointsEntity WHERE employeeNumber = :id')
  Future<PointsEntity?> getUserPointsById(int id);

  @insert
  Future<void> saveUserPoints(PointsEntity points);
}