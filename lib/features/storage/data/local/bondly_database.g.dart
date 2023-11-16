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
            'CREATE TABLE IF NOT EXISTS `UserEntity` (`employeeNumber` INTEGER NOT NULL, `id` TEXT, `completeName` TEXT, `role` TEXT, `accountNumber` TEXT, `accountHolder` TEXT, `email` TEXT, `isActive` INTEGER NOT NULL, `seats` INTEGER NOT NULL, `planType` TEXT, `monthlyPoints` INTEGER NOT NULL, `accountType` TEXT, `companyName` TEXT, `avatar` TEXT, `giftedPoints` INTEGER NOT NULL, `pointsReceived` INTEGER NOT NULL, `isVisible` INTEGER NOT NULL, `token` TEXT, PRIMARY KEY (`employeeNumber`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UsersDao get usersDao {
    return _usersDaoInstance ??= _$UsersDao(database, changeListener);
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
                  'id': item.id,
                  'completeName': item.completeName,
                  'role': item.role,
                  'accountNumber': item.accountNumber,
                  'accountHolder': item.accountHolder,
                  'email': item.email,
                  'isActive': item.isActive ? 1 : 0,
                  'seats': item.seats,
                  'planType': item.planType,
                  'monthlyPoints': item.monthlyPoints,
                  'accountType': item.accountType,
                  'companyName': item.companyName,
                  'avatar': item.avatar,
                  'giftedPoints': item.giftedPoints,
                  'pointsReceived': item.pointsReceived,
                  'isVisible': item.isVisible ? 1 : 0,
                  'token': item.token
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
            id: row['id'] as String?,
            completeName: row['completeName'] as String?,
            role: row['role'] as String?,
            accountNumber: row['accountNumber'] as String?,
            accountHolder: row['accountHolder'] as String?,
            email: row['email'] as String?,
            isActive: (row['isActive'] as int) != 0,
            seats: row['seats'] as int,
            planType: row['planType'] as String?,
            monthlyPoints: row['monthlyPoints'] as int,
            accountType: row['accountType'] as String?,
            companyName: row['companyName'] as String?,
            avatar: row['avatar'] as String?,
            giftedPoints: row['giftedPoints'] as int,
            pointsReceived: row['pointsReceived'] as int,
            isVisible: (row['isVisible'] as int) != 0,
            token: row['token'] as String?));
  }

  @override
  Stream<UserEntity?> getUserById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM UserEntity WHERE employeeNumber = ?1',
        mapper: (Map<String, Object?> row) => UserEntity(
            employeeNumber: row['employeeNumber'] as int,
            id: row['id'] as String?,
            completeName: row['completeName'] as String?,
            role: row['role'] as String?,
            accountNumber: row['accountNumber'] as String?,
            accountHolder: row['accountHolder'] as String?,
            email: row['email'] as String?,
            isActive: (row['isActive'] as int) != 0,
            seats: row['seats'] as int,
            planType: row['planType'] as String?,
            monthlyPoints: row['monthlyPoints'] as int,
            accountType: row['accountType'] as String?,
            companyName: row['companyName'] as String?,
            avatar: row['avatar'] as String?,
            giftedPoints: row['giftedPoints'] as int,
            pointsReceived: row['pointsReceived'] as int,
            isVisible: (row['isVisible'] as int) != 0,
            token: row['token'] as String?),
        arguments: [id],
        queryableName: 'UserEntity',
        isView: false);
  }

  @override
  Future<void> removeAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM UserEntity');
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    await _userEntityInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }
}
