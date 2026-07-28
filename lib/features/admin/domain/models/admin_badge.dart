class AdminBadgeCategory {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final bool visible;

  const AdminBadgeCategory({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.visible,
  });

  factory AdminBadgeCategory.fromJson(Map<String, dynamic> json) {
    return AdminBadgeCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      visible: json['visible'] as bool? ?? true,
    );
  }
}

class AdminBadge {
  final String id;
  final String categoryId;
  final String? categoryName;
  final String name;
  final String? image;
  final int value;
  final bool isActive;
  final DateTime? createdAt;

  const AdminBadge({
    required this.id,
    required this.categoryId,
    this.categoryName,
    required this.name,
    this.image,
    required this.value,
    required this.isActive,
    this.createdAt,
  });

  factory AdminBadge.fromJson(Map<String, dynamic> json) {
    final cat = json['badge_categories'] as Map<String, dynamic>?;
    return AdminBadge(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      categoryName: cat?['name'] as String?,
      name: json['name'] as String,
      image: json['image'] as String?,
      value: (json['value'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  AdminBadge copyWith({bool? isActive}) => AdminBadge(
        id: id,
        categoryId: categoryId,
        categoryName: categoryName,
        name: name,
        image: image,
        value: value,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt,
      );
}
