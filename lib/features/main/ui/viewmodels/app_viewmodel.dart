import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_state_usecase.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/screens/home_screen.dart';
import 'package:multiple_result/multiple_result.dart';

class AppModel extends NavigationModel {
  final GetLoginStateUseCase _useCase = getIt<GetLoginStateUseCase>();

  bool _loginState = false;
  bool get loginState => _loginState;

  void load() async {
    Result<bool, dynamic> result = _useCase.invoke();
    result.when(
        (success) => _loginState = success,
        (error) => _loginState = false
    );

    await Future.delayed(const Duration(milliseconds: 1500));
    if (!loginState) {
      navigation.go(
          LoginScreen.route
      );
    } else {
      navigation.go(
          HomeScreen.route
      );
    }
    notifyListeners();
  }
}
