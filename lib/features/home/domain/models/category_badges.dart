// To parse this JSON data, do
//
//     final badges = badgesFromJson(jsonString);

import 'dart:convert';

import 'package:bondly_app/features/home/domain/models/badge_model.dart';

Badges badgesFromJson(String str) => Badges.fromJson(json.decode(str));

class Badges {
  List<Badge> badges;

  Badges({
    required this.badges,
  });

  factory Badges.fromJson(Map<String, dynamic> json) => Badges(
        badges: json["data"] == null
            ? []
            : List<Badge>.from(json["data"]!.map((x) => Badge.fromJson(x))),
      );
}
