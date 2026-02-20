class RankedUser {
  final int position;
  final String name;
  final String? avatarUrl;
  final String? department;
  final int recognitionCount;

  const RankedUser({
    required this.position,
    required this.name,
    this.avatarUrl,
    this.department,
    required this.recognitionCount,
  });

  factory RankedUser.fromSupabase(Map<String, dynamic> json) {
    return RankedUser(
      position: (json['position'] as num).toInt(),
      name: json['complete_name'] as String? ?? '',
      avatarUrl: json['avatar'] as String?,
      department: json['job_position'] as String?,
      recognitionCount: (json['recognition_count'] as num).toInt(),
    );
  }
}
