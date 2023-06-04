import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:bondly_app/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  //we make sure that the WidgetsBinding is initialized before we initialize the DependencyManager
  WidgetsFlutterBinding.ensureInitialized();
  // Here we initialize the DependencyManager
  await DependencyManager().initialize();
  // Here we make sure that the AppModel is ready before we continue
  await getIt.isReady<AppModel>();
  // Here we make sure that all the models are ready before we continue
  await getIt.allReady();
  // Here we set the URL strategy for our web app.
  // It is safe to call this function when running on mobile or desktop as well.
  setPathUrlStrategy();
  // Here we run the app
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
