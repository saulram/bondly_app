class Points {
  int? current;
  int? temporal;

  Points({
    this.current,
    this.temporal,
  });

  Points copyWith({
    int? current,
    int? temporal,
  }) =>
      Points(
        current: current ?? this.current,
        temporal: temporal ?? this.temporal,
      );

  factory Points.fromJson(Map<String, dynamic> json) => Points(
    current: json["current"],
    temporal: json["temporal"],
  );

  Map<String, dynamic> toJson() => {
    "current": current,
    "temporal": temporal,
  };
}
