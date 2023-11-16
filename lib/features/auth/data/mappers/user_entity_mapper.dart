import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/storage/data/local/entities/user_entity.dart';

class UserEntityMapper {
  User map({
    required UserEntity from
  }) {
    return User(
        rewards: null,
        id: from.id,
        completeName: from.completeName,
        employeeNumber: from.employeeNumber,
        role: from.role,
        accountNumber: from.accountNumber,
        accountHolder: from.accountHolder,
        email: from.email,
        isActive: from.isActive,
        seats: from.seats,
        planType: from.planType,
        monthlyPoints: from.monthlyPoints,
        accountType: from.accountType,
        companyName: from.companyName,
        avatar: from.avatar,
        giftedPoints: from.giftedPoints,
        pointsReceived: from.pointsReceived,
        isVisible: from.isVisible,
        token: from.token
    );
  }

  UserEntity mapReverse(User from) {
    return UserEntity(
        id: from.id,
        completeName: from.completeName,
        employeeNumber: from.employeeNumber,
        role: from.role,
        accountNumber: from.accountNumber,
        accountHolder: from.accountHolder,
        email: from.email,
        isActive: from.isActive,
        seats: from.seats,
        planType: from.planType,
        monthlyPoints: from.monthlyPoints,
        accountType: from.accountType,
        companyName: from.companyName,
        avatar: from.avatar,
        giftedPoints: from.giftedPoints,
        pointsReceived: from.pointsReceived,
        isVisible: from.isVisible,
        token: from.token
    );
  }

}