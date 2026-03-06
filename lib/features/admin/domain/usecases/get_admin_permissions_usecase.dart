import 'package:bondly_app/features/admin/domain/repositories/admin_auth_repository.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:multiple_result/multiple_result.dart';

class GetAdminPermissionsUseCase {
  final AdminAuthRepository _repository;

  GetAdminPermissionsUseCase(this._repository);

  Future<Result<List<AdminModule>, Exception>> invoke(String userId) async {
    return _repository.getPermissions(userId);
  }
}
