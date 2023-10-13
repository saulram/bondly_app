import 'dart:async';

import 'package:bondly_app/features/storage/data/local/dao/points_dao.dart';
import 'package:bondly_app/features/storage/data/local/dao/upgrade_dao.dart';
import 'package:bondly_app/features/storage/data/local/dao/users_dao.dart';
import 'package:bondly_app/features/storage/data/local/entities/points_entity.dart';
import 'package:bondly_app/features/storage/data/local/entities/upgrade_entity.dart';
import 'package:bondly_app/features/storage/data/local/entities/user_entity.dart';
import 'package:floor/floor.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import '../string_list_converter.dart';

part 'bondly_database.g.dart';

@Database(version: 1, entities: [UserEntity, UpgradeEntity, PointsEntity])
abstract class AppDatabase extends FloorDatabase {
  UsersDao get usersDao;
  PointsDao get pointsDao;
  UpgradeDao get upgradeDao;
}