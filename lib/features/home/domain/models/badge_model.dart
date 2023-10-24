class Badge {
  final String? id;
  final String? categoryId;
  final String? name;
  final String? image;
  final int value;
  final bool isActive;
  final int v;
  final bool visible;

  Badge({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.image,
    required this.value,
    required this.isActive,
    required this.v,
    required this.visible,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['_id'],
      categoryId: json['category_id'],
      name: json['name'],
      image: json['image'],
      value: json['value'],
      isActive: json['isActive'],
      v: json['__v'],
      visible: json['visible'],
    );
  }
}
