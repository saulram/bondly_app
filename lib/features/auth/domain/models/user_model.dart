import 'dart:convert';

User userDataFromJson(String str) => User.fromJson(json.decode(str));

String userDataToJson(User data) => json.encode(data.toJson());

class User {
  Points? points;
  Upgrade? upgrade;
  List<String>? roles;
  bool? passChanged;
  List<String>? groups;
  List<String>? paths;
  String? completeName;
  int? employeeNumber;
  String? location;
  String? position;
  String? area;
  String? department;
  String? email;
  String? profileImage;
  String? token;
  bool? success;

  User({
    this.points,
    this.upgrade,
    this.roles,
    this.passChanged,
    this.groups,
    this.paths,
    this.completeName,
    this.employeeNumber,
    this.location,
    this.position,
    this.area,
    this.department,
    this.email,
    this.profileImage,
    this.token,
    this.success,
  });

  User copyWith({
    Points? points,
    Upgrade? upgrade,
    List<String>? roles,
    bool? passChanged,
    List<String>? groups,
    List<String>? paths,
    String? completeName,
    int? employeeNumber,
    String? location,
    String? position,
    String? area,
    String? department,
    String? email,
    String? profileImage,
    String? token,
    bool? success,
  }) =>
      User(
        points: points ?? this.points,
        upgrade: upgrade ?? this.upgrade,
        roles: roles ?? this.roles,
        passChanged: passChanged ?? this.passChanged,
        groups: groups ?? this.groups,
        paths: paths ?? this.paths,
        completeName: completeName ?? this.completeName,
        employeeNumber: employeeNumber ?? this.employeeNumber,
        location: location ?? this.location,
        position: position ?? this.position,
        area: area ?? this.area,
        department: department ?? this.department,
        email: email ?? this.email,
        profileImage: profileImage ?? this.profileImage,
        token: token ?? this.token,
        success: success ?? this.success,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
    points: json["points"] == null ? null : Points.fromJson(json["points"]),
    upgrade: json["upgrade"] == null ? null : Upgrade.fromJson(json["upgrade"]),
    roles: json["roles"] == null ? [] : List<String>.from(json["roles"]!.map((x) => x)),
    passChanged: json["passChanged"],
    groups: json["groups"] == null ? [] : List<String>.from(json["groups"]!.map((x) => x)),
    paths: json["paths"] == null ? [] : List<String>.from(json["paths"]!.map((x) => x)),
    completeName: json["completeName"],
    employeeNumber: json["employeeNumber"],
    location: json["location"],
    position: json["position"],
    area: json["area"],
    department: json["department"],
    email: json["email"],
    profileImage: json["profileImage"],
    token: json["token"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "points": points?.toJson(),
    "upgrade": upgrade?.toJson(),
    "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
    "passChanged": passChanged,
    "groups": groups == null ? [] : List<dynamic>.from(groups!.map((x) => x)),
    "paths": paths == null ? [] : List<dynamic>.from(paths!.map((x) => x)),
    "completeName": completeName,
    "employeeNumber": employeeNumber,
    "location": location,
    "position": position,
    "area": area,
    "department": department,
    "email": email,
    "profileImage": profileImage,
    "token": token,
    "success": success,
  };
}

class Points {
  int? current;
  int? temporal;

  Points({
    this.current,
    this.temporal,
  });

  Points copyWith({
    int? current,
    int? temporal,
  }) =>
      Points(
        current: current ?? this.current,
        temporal: temporal ?? this.temporal,
      );

  factory Points.fromJson(Map<String, dynamic> json) => Points(
    current: json["current"],
    temporal: json["temporal"],
  );

  Map<String, dynamic> toJson() => {
    "current": current,
    "temporal": temporal,
  };
}

class Upgrade {
  int? result;
  String? badge;

  Upgrade({
    this.result,
    this.badge,
  });

  Upgrade copyWith({
    int? result,
    String? badge,
  }) =>
      Upgrade(
        result: result ?? this.result,
        badge: badge ?? this.badge,
      );

  factory Upgrade.fromJson(Map<String, dynamic> json) => Upgrade(
    result: json["result"],
    badge: json["badge"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "badge": badge,
  };
}
