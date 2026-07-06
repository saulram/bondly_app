import 'package:bondly_app/features/admin/domain/models/admin_module.dart';

class AdminPermission {
  final String id;
  final String userId;
  final AdminModule permission;
  final String? grantedBy;
  final DateTime? createdAt;

  const AdminPermission({
    required this.id,
    required this.userId,
    required this.permission,
    this.grantedBy,
    this.createdAt,
  });

  factory AdminPermission.fromJson(Map<String, dynamic> json) {
    return AdminPermission(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      permission: AdminModule.fromString(json['permission'] as String) ??
          (throw FormatException(
              'Unknown admin permission: ${json['permission']}')),
      grantedBy: json['granted_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'permission': permission.value,
        'granted_by': grantedBy,
        'created_at': createdAt?.toIso8601String(),
      };
}
