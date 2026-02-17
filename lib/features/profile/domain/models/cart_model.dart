class UserCart {
  final String id;
  final String userId;
  final List<CartItem> rewards;
  final String type;
  final String companyName;
  final String createdAt;
  final String updatedAt;
  final int total;

  UserCart({
    this.id = '',
    this.userId = '',
    required this.rewards,
    this.type = '',
    this.companyName = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.total = 0,
  });

  factory UserCart.fromSupabase(Map<String, dynamic> json) {
    List<CartItem> rewards = <CartItem>[];
    if (json['cart_items'] != null) {
      rewards = List<CartItem>.from(
          json['cart_items'].map((item) => CartItem.fromSupabase(item)));
    }

    return UserCart(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      rewards: rewards,
      type: json['type'] ?? '',
      companyName: json['company_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      total: json['total'] ?? 0,
    );
  }

  factory UserCart.fromJson(Map<String, dynamic> json) {
    List<CartItem> rewards = <CartItem>[];
    if (json['rewards'] != null) {
      rewards = List<CartItem>.from(
          json['rewards'].map((reward) => CartItem.fromJson(reward)));
    }

    // Verificar si las propiedades son nulas y asignar valores predeterminados si es necesario
    final id = json['_id'];
    final userId = json['user_id'] as String? ?? '';
    final type = json['type'] as String? ?? '';
    final companyName = json['companyName'] as String? ?? '';

    final createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt']!)
        : null;
    final updatedAt = json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt']!)
        : null;

    final total = json['total'] as int? ?? 0;

    return UserCart(
      id: id,
      userId: userId,
      rewards: rewards,
      type: type,
      companyName: companyName,
      createdAt: createdAt?.toIso8601String() ?? '',
      updatedAt: updatedAt?.toIso8601String() ?? '',
      total: total,
    );
  }
}

class CartItem {
  final Reward reward;
  final int quantity;
  final String id;

  CartItem({
    required this.reward,
    required this.quantity,
    required this.id,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      reward: Reward.fromJson(json['reward']),
      quantity: json['quantity'],
      id: json['_id'],
    );
  }

  factory CartItem.fromSupabase(Map<String, dynamic> json) {
    return CartItem(
      reward: Reward.fromSupabase(json['reward'] ?? {}),
      quantity: json['quantity'] ?? 0,
      id: json['id'] ?? '',
    );
  }
}

class Reward {
  final String id;
  final String name;
  final String description;
  final String category;
  final int points;
  final String image;
  DateTime? deadline;
  final String companyName;
  final bool enable;
  final bool visible;
  final List<dynamic> likes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;

  Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.points,
    required this.image,
    required this.deadline,
    required this.companyName,
    required this.enable,
    required this.visible,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      points: json['points'],
      image: json['image'],
      deadline:
          json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
      companyName: json['companyName'],
      enable: json['enable'],
      visible: json['visible'],
      likes: List<dynamic>.from(json['likes']),
      createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt:
          json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      imageUrl: json['imageUrl'],
    );
  }

  factory Reward.fromSupabase(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      points: json['points'] ?? 0,
      image: json['image'] ?? '',
      deadline:
          json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
      companyName: json['company_name'] ?? '',
      enable: json['enable'] ?? true,
      visible: json['visible'] ?? true,
      likes: json['likes'] != null ? List<dynamic>.from(json['likes']) : [],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      imageUrl: json['image_url'],
    );
  }
}
