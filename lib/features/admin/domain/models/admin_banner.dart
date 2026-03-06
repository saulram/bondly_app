class AdminBanner {
  final String id;
  final String name;
  final String? slug;
  final String? image;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;

  const AdminBanner({
    required this.id,
    required this.name,
    this.slug,
    this.image,
    this.description,
    required this.isActive,
    this.createdAt,
  });

  factory AdminBanner.fromJson(Map<String, dynamic> json) {
    return AdminBanner(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  AdminBanner copyWith({bool? isActive}) => AdminBanner(
        id: id,
        name: name,
        slug: slug,
        image: image,
        description: description,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt,
      );
}
