import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:bondly_app/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> main() async {
  //we make sure that the WidgetsBinding is initialized before we initialize the DependencyManager
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();
  // Here we initialize the DependencyManager
  await DependencyManager().initialize();
  // Here we make sure that the AppModel is ready before we continue
  await getIt.isReady<AppModel>();
  // Here we make sure that all the models are ready before we continue
  await getIt.allReady();
  // Here we set the URL strategy for our web app.

  // Here we run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppTheme>(
          create: (context) => AppTheme(),
        ),
      ],
      child: const BondlyApp(),
    ),
  );
}

class BondlyApp extends StatefulWidget {
  const BondlyApp({super.key});

  @override
  State<BondlyApp> createState() => _BondlyAppState();
}

class _BondlyAppState extends State<BondlyApp> {
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
          theme: context.watch<AppTheme>().lightTheme,
          darkTheme: context.watch<AppTheme>().darkTheme,
          routerConfig: modelApp.navigation,
        );
      }),
    );
  }
}
