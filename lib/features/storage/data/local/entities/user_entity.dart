import 'package:floor/floor.dart';

@entity
class UserEntity {
  @primaryKey
  int employeeNumber = 1;
  String? id;
  String? completeName;
  String? role;
  String? accountNumber;
  String? accountHolder;
  String? email;
  bool isActive;
  int seats;
  String? planType;
  int monthlyPoints;
  String? accountType;
  String? companyName;
  String? avatar;
  int giftedPoints;
  int pointsReceived;
  bool isVisible;
  String? token;

  UserEntity({
    required this.employeeNumber,
    this.id,
    this.completeName,
    this.role,
    this.accountNumber,
    this.accountHolder,
    this.email,
    this.isActive = false,
    this.seats = 0,
    this.planType,
    this.monthlyPoints = 0,
    this.accountType,
    this.companyName,
    this.avatar,
    this.giftedPoints = 0,
    this.pointsReceived = 0,
    this.isVisible = false,
    this.token
  });
}
