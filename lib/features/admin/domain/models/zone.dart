class Zone {
  final String id;
  final String name;
  final String? description;
  final String? companyName;
  final String? parentZoneId;
  final bool isActive;
  final DateTime? createdAt;

  const Zone({
    required this.id,
    required this.name,
    this.description,
    this.companyName,
    this.parentZoneId,
    this.isActive = true,
    this.createdAt,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      companyName: json['company_name'] as String?,
      parentZoneId: json['parent_zone_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'company_name': companyName,
        'parent_zone_id': parentZoneId,
        'is_active': isActive,
        'created_at': createdAt?.toIso8601String(),
      };
}
