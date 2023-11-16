import 'package:bondly_app/dependencies/api_provider.dart';
import 'package:bondly_app/dependencies/handlers_provider.dart';
import 'package:bondly_app/dependencies/repository_provider.dart';
import 'package:bondly_app/dependencies/service_provider.dart';
import 'package:bondly_app/dependencies/storage_objects_provider.dart';
import 'package:bondly_app/dependencies/usecase_provider.dart';
import 'package:bondly_app/dependencies/viewmodel_provider.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.I;

class DependencyManager {
  Future<void> initialize() async {
    await StorageObjectsProvider.provide();
    HandlersProvider.provide();
    APIProvider.provide();
    RepositoryProvider.provide();
    UseCaseProvider.provide();
    ViewModelProvider.provide();
    ServiceProvider.provide();
    await getIt.allReady();
  }

  Future<void> dispose() async {
    return await getIt.reset(dispose: true);
  }
}
