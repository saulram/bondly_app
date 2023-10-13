class Upgrade {
  int? result;
  String? badge;

  Upgrade({
    this.result,
    this.badge,
  });

  Upgrade copyWith({
    int? result,
    String? badge,
  }) =>
      Upgrade(
        result: result ?? this.result,
        badge: badge ?? this.badge,
      );

  factory Upgrade.fromJson(Map<String, dynamic> json) => Upgrade(
    result: json["result"],
    badge: json["badge"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "badge": badge,
  };
}