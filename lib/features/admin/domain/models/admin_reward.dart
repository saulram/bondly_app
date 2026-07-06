class AdminReward {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final int points;
  final String? image;
  final DateTime? deadline;
  final bool enable;
  final DateTime? createdAt;

  const AdminReward({
    required this.id,
    required this.name,
    this.description,
    this.category,
    required this.points,
    this.image,
    this.deadline,
    required this.enable,
    this.createdAt,
  });

  factory AdminReward.fromJson(Map<String, dynamic> json) {
    return AdminReward(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      points: (json['points'] as num?)?.toInt() ?? 0,
      image: json['image'] as String?,
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'] as String)
          : null,
      enable: json['enable'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  AdminReward copyWith({bool? enable}) => AdminReward(
        id: id,
        name: name,
        description: description,
        category: category,
        points: points,
        image: image,
        deadline: deadline,
        enable: enable ?? this.enable,
        createdAt: createdAt,
      );
}
