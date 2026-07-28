import 'package:bondly_app/features/auth/domain/models/user_model.dart';

class UserProfile {
  final User user;
  final String companyName;
  final String jobPosition;
  final String location;
  final DateTime dob;
  final String id;

  UserProfile(
    this.user,
    this.companyName,
    this.jobPosition,
    this.location,
    this.dob,
    this.id,
  );

  factory UserProfile.fromSupabase(Map<String, dynamic> json) {
    final profileData = json['user_profiles'] is List &&
            (json['user_profiles'] as List).isNotEmpty
        ? (json['user_profiles'] as List).first as Map<String, dynamic>
        : json['user_profiles'] is Map
            ? json['user_profiles'] as Map<String, dynamic>
            : <String, dynamic>{};

    return UserProfile(
      User.fromSupabase(json),
      json['company_name'] ?? '',
      profileData['job_position'] ?? '',
      profileData['location'] ?? '',
      profileData['b_day'] != null
          ? DateTime.parse(profileData['b_day'])
          : DateTime.now(),
      profileData['id'] ?? json['id'] ?? '',
    );
  }
}
