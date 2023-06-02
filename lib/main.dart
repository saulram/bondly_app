import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/domain/viewmodels/app_viewmodel.dart';
import 'package:bondly_app/domain/viewmodels/base_model.dart';
import 'package:bondly_app/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyManager().initialize();
  await getIt.isReady<AppModel>();
  await getIt.allReady();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppModel appModel;
  late AppRouter appRouter;

  @override
  void initState() {
    initAppModel();
    super.initState();
  }

  Future<void> initAppModel() async {
    appModel = getIt<AppModel>();
    appModel.onAppStart();
  }

  @override
  Widget build(BuildContext context) {
    return ModelProvider(
      model: appModel,
      child: ModelBuilder<AppModel>(builder: (context, modelApp, child) {
        return MaterialApp.router(
          title: 'BondlyApp',
          routerConfig: modelApp.navigation,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        );
      }),
    );
  }
}
