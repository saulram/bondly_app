// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bondly_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UsersDao? _usersDaoInstance;

  PointsDao? _pointsDaoInstance;

  UpgradeDao? _upgradeDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserEntity` (`employeeNumber` INTEGER NOT NULL, `passChanged` INTEGER, `completeName` TEXT, `location` TEXT, `position` TEXT, `area` TEXT, `department` TEXT, `email` TEXT, `profileImage` TEXT, `token` TEXT, `success` INTEGER, `roles` TEXT NOT NULL, `groups` TEXT NOT NULL, `paths` TEXT NOT NULL, PRIMARY KEY (`employeeNumber`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UpgradeEntity` (`employeeNumber` INTEGER NOT NULL, `result` INTEGER, `badge` TEXT, PRIMARY KEY (`employeeNumber`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `PointsEntity` (`employeeId` INTEGER NOT NULL, `current` INTEGER, `temporal` INTEGER, PRIMARY KEY (`employeeId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UsersDao get usersDao {
    return _usersDaoInstance ??= _$UsersDao(database, changeListener);
  }

  @override
  PointsDao get pointsDao {
    return _pointsDaoInstance ??= _$PointsDao(database, changeListener);
  }

  @override
  UpgradeDao get upgradeDao {
    return _upgradeDaoInstance ??= _$UpgradeDao(database, changeListener);
  }
}

class _$UsersDao extends UsersDao {
  _$UsersDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _userEntityInsertionAdapter = InsertionAdapter(
            database,
            'UserEntity',
            (UserEntity item) => <String, Object?>{
                  'employeeNumber': item.employeeNumber,
                  'passChanged': item.passChanged == null
                      ? null
                      : (item.passChanged! ? 1 : 0),
                  'completeName': item.completeName,
                  'location': item.location,
                  'position': item.position,
                  'area': item.area,
                  'department': item.department,
                  'email': item.email,
                  'profileImage': item.profileImage,
                  'token': item.token,
                  'success':
                      item.success == null ? null : (item.success! ? 1 : 0),
                  'roles': _stringListConverter.encode(item.roles),
                  'groups': _stringListConverter.encode(item.groups),
                  'paths': _stringListConverter.encode(item.paths)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserEntity> _userEntityInsertionAdapter;

  @override
  Future<List<UserEntity>> getUsers() async {
    return _queryAdapter.queryList('SELECT * FROM UserEntity',
        mapper: (Map<String, Object?> row) => UserEntity(
            employeeNumber: row['employeeNumber'] as int,
            roles: _stringListConverter.decode(row['roles'] as String),
            groups: _stringListConverter.decode(row['groups'] as String),
            paths: _stringListConverter.decode(row['paths'] as String),
            passChanged: row['passChanged'] == null
                ? null
                : (row['passChanged'] as int) != 0,
            completeName: row['completeName'] as String?,
            location: row['location'] as String?,
            position: row['position'] as String?,
            area: row['area'] as String?,
            department: row['department'] as String?,
            email: row['email'] as String?,
            profileImage: row['profileImage'] as String?,
            token: row['token'] as String?,
            success:
                row['success'] == null ? null : (row['success'] as int) != 0));
  }

  @override
  Stream<UserEntity?> getUserById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM UserEntity WHERE employeeNumber = ?1',
        mapper: (Map<String, Object?> row) => UserEntity(
            employeeNumber: row['employeeNumber'] as int,
            roles: _stringListConverter.decode(row['roles'] as String),
            groups: _stringListConverter.decode(row['groups'] as String),
            paths: _stringListConverter.decode(row['paths'] as String),
            passChanged: row['passChanged'] == null
                ? null
                : (row['passChanged'] as int) != 0,
            completeName: row['completeName'] as String?,
            location: row['location'] as String?,
            position: row['position'] as String?,
            area: row['area'] as String?,
            department: row['department'] as String?,
            email: row['email'] as String?,
            profileImage: row['profileImage'] as String?,
            token: row['token'] as String?,
            success:
                row['success'] == null ? null : (row['success'] as int) != 0),
        arguments: [id],
        queryableName: 'UserEntity',
        isView: false);
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    await _userEntityInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }
}

class _$PointsDao extends PointsDao {
  _$PointsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _pointsEntityInsertionAdapter = InsertionAdapter(
            database,
            'PointsEntity',
            (PointsEntity item) => <String, Object?>{
                  'employeeId': item.employeeId,
                  'current': item.current,
                  'temporal': item.temporal
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PointsEntity> _pointsEntityInsertionAdapter;

  @override
  Future<List<PointsEntity>> getUserPoints() async {
    return _queryAdapter.queryList('SELECT * FROM PointsEntity',
        mapper: (Map<String, Object?> row) => PointsEntity(
            employeeId: row['employeeId'] as int,
            current: row['current'] as int?,
            temporal: row['temporal'] as int?));
  }

  @override
  Future<PointsEntity?> getUserPointsById(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM PointsEntity WHERE employeeNumber = ?1',
        mapper: (Map<String, Object?> row) => PointsEntity(
            employeeId: row['employeeId'] as int,
            current: row['current'] as int?,
            temporal: row['temporal'] as int?),
        arguments: [id]);
  }

  @override
  Future<void> saveUserPoints(PointsEntity points) async {
    await _pointsEntityInsertionAdapter.insert(
        points, OnConflictStrategy.abort);
  }
}

class _$UpgradeDao extends UpgradeDao {
  _$UpgradeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _upgradeEntityInsertionAdapter = InsertionAdapter(
            database,
            'UpgradeEntity',
            (UpgradeEntity item) => <String, Object?>{
                  'employeeNumber': item.employeeNumber,
                  'result': item.result,
                  'badge': item.badge
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UpgradeEntity> _upgradeEntityInsertionAdapter;

  @override
  Future<List<UpgradeEntity>> getUserUpgrade() async {
    return _queryAdapter.queryList('SELECT * FROM UpgradeEntity',
        mapper: (Map<String, Object?> row) => UpgradeEntity(
            employeeNumber: row['employeeNumber'] as int,
            result: row['result'] as int?,
            badge: row['badge'] as String?));
  }

  @override
  Future<UpgradeEntity?> getUserUpgradeById(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM UpgradeEntity WHERE employeeNumber = ?1',
        mapper: (Map<String, Object?> row) => UpgradeEntity(
            employeeNumber: row['employeeNumber'] as int,
            result: row['result'] as int?,
            badge: row['badge'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> saveUserUpgrade(UpgradeEntity upgrade) async {
    await _upgradeEntityInsertionAdapter.insert(
        upgrade, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _stringListConverter = StringListConverter();
