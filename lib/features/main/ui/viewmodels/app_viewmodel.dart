import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_state_usecase.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

class AppModel extends NavigationModel {
  final GetLoginStateUseCase _useCase = getIt<GetLoginStateUseCase>();

  Logger log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  bool _loginState = false;
  bool get loginState => _loginState;

  Future<void> load() async {
    Result<bool, dynamic> result = await _useCase.invoke();
    result.when(
      (success) => _loginState = success,
      (error) => _loginState = false
    );
  }
}
