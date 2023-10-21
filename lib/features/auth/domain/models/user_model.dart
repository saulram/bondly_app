import 'dart:convert';

import 'package:bondly_app/config/strings_main.dart';

User userDataFromJson(String str) => User.fromJson(json.decode(str));

String userDataToJson(User data) => json.encode(data.toJson());

class User {
  List<dynamic>? rewards;
  String? id;
  String? completeName;
  int employeeNumber;
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

  User({
    this.rewards,
    this.id,
    this.completeName,
    this.employeeNumber = 1,
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

  factory User.fromJson(Map<String, dynamic> map) {
    Map<String, dynamic> json = map["data"];
    return User(
      rewards: json["rewards"] == null ? [] : List<dynamic>.from(json["rewards"]!.map((x) => x)),
      id: json["_id"],
      completeName: json["completeName"],
      employeeNumber: json["employeeNumber"] ?? 1,
      role: json["role"],
      accountNumber: json["accountNumber"].toString(),
      accountHolder: json["accountHolder"],
      email: json["email"],
      isActive: json["isActive"] ?? false,
      seats: json["seats"] ?? 0,
      planType: json["planType"],
      monthlyPoints: json["monthlyPoints"] ?? 0,
      accountType: json["accountType"],
      companyName: json["companyName"],
      avatar: json["avatar"] == null || json["avatar"].toString().contains("http")
          ? json["avatar"]
          : StringsMain.baseImagesUrl + json["avatar"].toString(),
      giftedPoints: json["giftedPoints"] ?? 0,
      pointsReceived: json["pointsReceived"] ?? 0,
      isVisible: json["visible"] ?? false,
      token: map["token"]
    );
  }

  Map<String, dynamic> toJson() => {
    "rewards": rewards == null ? [] : List<dynamic>.from(rewards!.map((x) => x)),
    "_id": id,
    "completeName": completeName,
    "employeeNumber": employeeNumber,
    "role": role,
    "accountNumber": accountNumber,
    "accountHolder": accountHolder,
    "email": email,
    "isActive": isActive,
    "seats": seats,
    "planType": planType,
    "monthlyPoints": monthlyPoints,
    "accountType": accountType,
    "companyName": companyName,
    "avatar": avatar,
    "giftedPoints": giftedPoints,
    "pointsReceived": pointsReceived,
    "visible": isVisible,
    "token": token,
  };
}
