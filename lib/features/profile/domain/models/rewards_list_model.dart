// To parse this JSON data, do
//
//     final rewardList = rewardListFromJson(jsonString);

import 'dart:convert';

import 'package:bondly_app/features/profile/domain/models/cart_model.dart';

RewardList rewardListFromJson(String str) =>
    RewardList.fromJson(json.decode(str));

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
        rewards: json["data"] == null
            ? []
            : List<Reward>.from(json["data"]!.map((x) => Reward.fromJson(x))),
      );
}
