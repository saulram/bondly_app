import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/storage/data/local/bondly_database.dart';
import 'package:bondly_app/features/storage/data/local/dao/users_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageObjectsProvider {
  static Future<void> provide() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    getIt.registerSingletonAsync<AppDatabase>(
            () async => $FloorAppDatabase.databaseBuilder('bondly.db').build());

    getIt.registerSingletonWithDependencies<UsersDao>(() {
      return getIt<AppDatabase>().usersDao;
    }, dependsOn: [AppDatabase]);
  }
}