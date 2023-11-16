class Badge {
  final String? id;
  final String? categoryId;
  final String? name;
  final String? image;
  final int value;
  final bool isActive;

  Badge({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.image,
    required this.value,
    required this.isActive,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['_id'],
      categoryId: json['category_id'],
      name: json['name'],
      image: json['image'],
      value: json['value'],
      isActive: json['isActive'],
    );
  }
}
