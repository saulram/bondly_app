import 'dart:async';

import 'package:bondly_app/features/storage/data/local/dao/users_dao.dart';
import 'package:bondly_app/features/storage/data/local/entities/user_entity.dart';
import 'package:floor/floor.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

part 'bondly_database.g.dart';

/// The database creation and definition, we have to add here the DB version,
/// entities (marked with @dao) and then, the DAOs definition as global variables.
///
/// Every time we edit DAOs or database, run
/// [flutter packages pub run build_runner build]

@Database(version: 1, entities: [UserEntity])
abstract class AppDatabase extends FloorDatabase {
  UsersDao get usersDao;
}