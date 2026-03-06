class AdminUser {
  final String id;
  final String? completeName;
  final String email;
  final String role;
  final bool isActive;
  final String? companyName;
  final String? avatar;
  final int monthlyPoints;
  final int pointsReceived;
  final int giftedPoints;
  final DateTime? createdAt;

  const AdminUser({
    required this.id,
    this.completeName,
    required this.email,
    required this.role,
    required this.isActive,
    this.companyName,
    this.avatar,
    required this.monthlyPoints,
    required this.pointsReceived,
    required this.giftedPoints,
    this.createdAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String,
      completeName: json['complete_name'] as String?,
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'client',
      isActive: json['is_active'] as bool? ?? true,
      companyName: json['company_name'] as String?,
      avatar: json['avatar'] as String?,
      monthlyPoints: (json['monthly_points'] as num?)?.toInt() ?? 0,
      pointsReceived: (json['points_received'] as num?)?.toInt() ?? 0,
      giftedPoints: (json['gifted_points'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  AdminUser copyWith({bool? isActive, String? role}) {
    return AdminUser(
      id: id,
      completeName: completeName,
      email: email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      companyName: companyName,
      avatar: avatar,
      monthlyPoints: monthlyPoints,
      pointsReceived: pointsReceived,
      giftedPoints: giftedPoints,
      createdAt: createdAt,
    );
  }
}
