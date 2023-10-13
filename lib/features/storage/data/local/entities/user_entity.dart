import 'package:bondly_app/features/storage/data/string_list_converter.dart';
import 'package:floor/floor.dart';

@entity
class UserEntity {
  @primaryKey
  int employeeNumber = 1;
  bool? passChanged;
  String? completeName;
  String? location;
  String? position;
  String? area;
  String? department;
  String? email;
  String? profileImage;
  String? token;
  bool? success;


  @TypeConverters([StringListConverter])
  List<String> roles;
  @TypeConverters([StringListConverter])
  List<String> groups;
  @TypeConverters([StringListConverter])
  List<String> paths;

  UserEntity({
    required this.employeeNumber,
    this.roles = const [],
    this.groups = const [],
    this.paths = const [],
    this.passChanged,
    this.completeName,
    this.location,
    this.position,
    this.area,
    this.department,
    this.email,
    this.profileImage,
    this.token,
    this.success,
  });
}
