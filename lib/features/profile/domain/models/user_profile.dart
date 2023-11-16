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
}