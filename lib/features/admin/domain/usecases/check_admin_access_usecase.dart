import 'package:bondly_app/features/admin/domain/repositories/admin_auth_repository.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:multiple_result/multiple_result.dart';

class CheckAdminAccessUseCase {
  final AdminAuthRepository _repository;

  CheckAdminAccessUseCase(this._repository);

  Future<Result<bool, Exception>> invoke(
      String userId, AdminModule module) async {
    return _repository.hasPermission(userId, module);
  }
}
