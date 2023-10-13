import 'package:bondly_app/features/auth/domain/models/points_model.dart';
import 'package:bondly_app/features/auth/domain/models/upgrade_model.dart';
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/storage/data/local/entities/user_entity.dart';

class UserEntityMapper {
  User map({
    required UserEntity from,
    Points? points,
    Upgrade? upgrade
  }) {
    return User(
      points: points,
      upgrade: upgrade,
      roles: from.roles,
      groups: from.groups,
      paths: from.paths,
      passChanged: from.passChanged,
      position: from.position,
      profileImage: from.profileImage,
      success: from.success,
      email: from.email,
      employeeNumber: from.employeeNumber,
      area: from.area,
      department: from.department,
      token: from.token,
      location: from.location,
      completeName: from.completeName
    );
  }

  UserEntity mapReverse(User from) {
    return UserEntity(
        roles: from.roles ?? [],
        groups: from.groups ?? [],
        paths: from.paths ?? [],
        passChanged: from.passChanged,
        position: from.position,
        profileImage: from.profileImage,
        success: from.success,
        email: from.email,
        employeeNumber: from.employeeNumber ?? 1,
        area: from.area,
        department: from.department,
        token: from.token,
        location: from.location,
        completeName: from.completeName
    );
  }

}