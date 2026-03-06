class AdminExchange {
  final String id;
  final String userId;
  final String? userName;
  final String? userEmail;
  final String rewardId;
  final String? rewardName;
  final String? code;
  final String status;
  final DateTime? createdAt;

  const AdminExchange({
    required this.id,
    required this.userId,
    this.userName,
    this.userEmail,
    required this.rewardId,
    this.rewardName,
    this.code,
    required this.status,
    this.createdAt,
  });

  factory AdminExchange.fromJson(Map<String, dynamic> json) {
    final user = json['users'] as Map<String, dynamic>?;
    final reward = json['rewards'] as Map<String, dynamic>?;
    return AdminExchange(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: user?['complete_name'] as String?,
      userEmail: user?['email'] as String?,
      rewardId: json['reward_id'] as String,
      rewardName: reward?['name'] as String?,
      code: json['code'] as String?,
      status: json['status'] as String? ?? 'En espera',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  AdminExchange copyWith({String? status}) => AdminExchange(
        id: id,
        userId: userId,
        userName: userName,
        userEmail: userEmail,
        rewardId: rewardId,
        rewardName: rewardName,
        code: code,
        status: status ?? this.status,
        createdAt: createdAt,
      );
}
