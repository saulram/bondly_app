class AdminAmbassador {
  final String id;
  final String userId;
  final String? userName;
  final String? userEmail;
  final String? userAvatar;
  final String? badgeId;
  final String? badgeName;
  final String? badgeImage;
  final DateTime? date;
  final bool visible;

  const AdminAmbassador({
    required this.id,
    required this.userId,
    this.userName,
    this.userEmail,
    this.userAvatar,
    this.badgeId,
    this.badgeName,
    this.badgeImage,
    this.date,
    this.visible = true,
  });

  factory AdminAmbassador.fromJson(Map<String, dynamic> json) {
    final userMap = json['users'] as Map<String, dynamic>?;
    final badgeMap = json['badges'] as Map<String, dynamic>?;
    return AdminAmbassador(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: userMap?['complete_name'] as String?,
      userEmail: userMap?['email'] as String?,
      userAvatar: userMap?['avatar'] as String?,
      badgeId: json['badge_id'] as String?,
      badgeName: badgeMap?['name'] as String?,
      badgeImage: badgeMap?['image'] as String?,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String)
          : null,
      visible: json['visible'] as bool? ?? true,
    );
  }
}
