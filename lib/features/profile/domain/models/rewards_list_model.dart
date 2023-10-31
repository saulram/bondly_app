// To parse this JSON data, do
//
//     final rewardList = rewardListFromJson(jsonString);

import 'dart:convert';

RewardList rewardListFromJson(String str) =>
    RewardList.fromJson(json.decode(str));

String rewardListToJson(RewardList data) => json.encode(data.toJson());

class RewardList {
  List<Reward>? rewards;

  RewardList({
    this.rewards,
  });

  RewardList copyWith({
    List<Reward>? rewards,
  }) =>
      RewardList(
        rewards: rewards ?? this.rewards,
      );

  factory RewardList.fromJson(Map<String, dynamic> json) => RewardList(
        rewards: json["rewards"] == null
            ? []
            : List<Reward>.from(
                json["rewards"]!.map((x) => Reward.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rewards": rewards == null
            ? []
            : List<dynamic>.from(rewards!.map((x) => x.toJson())),
      };
}

class Reward {
  String? id;
  String? name;
  String? description;
  String? category;
  int? points;
  DateTime? deadline;
  String? companyName;
  bool? enable;
  bool? visible;
  List<dynamic>? likes;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;

  Reward({
    this.id,
    this.name,
    this.description,
    this.category,
    this.points,
    this.deadline,
    this.companyName,
    this.enable,
    this.visible,
    this.likes,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  Reward copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? points,
    DateTime? deadline,
    String? companyName,
    bool? enable,
    bool? visible,
    List<dynamic>? likes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? image,
  }) =>
      Reward(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        category: category ?? this.category,
        points: points ?? this.points,
        deadline: deadline ?? this.deadline,
        companyName: companyName ?? this.companyName,
        enable: enable ?? this.enable,
        visible: visible ?? this.visible,
        likes: likes ?? this.likes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        image: image ?? this.image,
      );

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        category: json["category"],
        points: json["points"],
        deadline:
            json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
        companyName: json["companyName"],
        enable: json["enable"],
        visible: json["visible"],
        likes: json["likes"] == null
            ? []
            : List<dynamic>.from(json["likes"]!.map((x) => x)),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "category": category,
        "points": points,
        "deadline": deadline?.toIso8601String(),
        "companyName": companyName,
        "enable": enable,
        "visible": visible,
        "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "image": image,
      };
}
