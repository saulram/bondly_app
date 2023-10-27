// To parse this JSON data, do
//
//     final embassys = embassysFromJson(jsonString);

import 'dart:convert';

import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/home/domain/models/badge_model.dart';

Embassys embassysFromJson(String str) => Embassys.fromJson(json.decode(str));

class Embassys {
  List<Embassy>? embassy;

  Embassys({
    this.embassy,
  });

  Embassys copyWith({
    List<Embassy>? embassy,
  }) =>
      Embassys(
        embassy: embassy ?? this.embassy,
      );

  factory Embassys.fromJson(Map<String, dynamic> json) => Embassys(
        embassy: json["data"] == null
            ? []
            : List<Embassy>.from(json["data"]!.map((x) => Embassy.fromJson(x))),
      );
}

class Embassy {
  String? id;
  User? userId;
  Badge? badgeId;
  DateTime? date;

  Embassy({
    this.id,
    this.userId,
    this.badgeId,
    this.date,
  });

  Embassy copyWith({
    String? id,
    User? userId,
    Badge? badgeId,
    DateTime? date,
  }) =>
      Embassy(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        badgeId: badgeId ?? this.badgeId,
        date: date ?? this.date,
      );

  factory Embassy.fromJson(Map<String, dynamic> json) => Embassy(
        id: json["_id"],
        userId: json["user_id"] == null
            ? null
            : User.fromSingleJson(json["user_id"]),
        badgeId:
            json["badge_id"] == null ? null : Badge.fromJson(json["badge_id"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );
}
