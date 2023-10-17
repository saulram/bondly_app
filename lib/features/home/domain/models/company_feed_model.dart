import 'dart:convert';

List<FeedPost> feedPostFromJson(String str) =>
    List<FeedPost>.from(json.decode(str).map((x) => FeedPost.fromJson(x)));

String feedPostToJson(List<FeedPost> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeedPost {
  String? id;
  int? account;
  String? header;
  String? body;
  String? footer;
  Map<String, dynamic>? senderId;
  String? type;
  Map<String, dynamic>? badgeId;
  List<Comment>? comments;
  List<Like>? likes;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? visible;
  String? image;

  FeedPost({
    this.id,
    this.account,
    this.header,
    this.body,
    this.footer,
    this.senderId,
    this.type,
    this.badgeId,
    this.comments,
    this.likes,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.visible,
    this.image,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) => FeedPost(
        id: json["_id"],
        account: json["account"],
        header: json["header"],
        body: json["body"],
        footer: json["footer"],
        senderId: json["sender_id"] == null ? null : json["sender_id"],
        type: json["type"],
        badgeId: json["badge_id"] == null ? null : json["badge_id"],
        comments: json["comments"] == null
            ? []
            : List<Comment>.from(
                json["comments"]!.map((x) => Comment.fromJson(x))),
        likes: json["likes"] == null
            ? []
            : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        visible: json["visible"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "account": account,
        "header": header,
        "body": body,
        "footer": footer,
        "sender_id": senderId,
        "type": type,
        "badge_id": badgeId,
        "comments": comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "likes": likes == null
            ? []
            : List<dynamic>.from(likes!.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "visible": visible,
        "image": image,
      };
}

class BadgeId {
  String? id;
  String? categoryId;
  String? name;
  String? image;
  int? value;
  bool? isActive;
  int? v;
  bool? visible;

  BadgeId({
    this.id,
    this.categoryId,
    this.name,
    this.image,
    this.value,
    this.isActive,
    this.v,
    this.visible,
  });

  factory BadgeId.fromJson(Map<String, dynamic> json) => BadgeId(
        id: json["_id"],
        categoryId: json["category_id"],
        name: json["name"],
        image: json["image"],
        value: json["value"],
        isActive: json["isActive"],
        v: json["__v"],
        visible: json["visible"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category_id": categoryId,
        "name": name,
        "image": image,
        "value": value,
        "isActive": isActive,
        "__v": v,
        "visible": visible,
      };
}

class Comment {
  Map<String, dynamic>? userId;
  String? message;
  DateTime? timeStamp;
  String? id;

  Comment({
    this.userId,
    this.message,
    this.timeStamp,
    this.id,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        userId: json["user_id"] == null ? null : json["user_id"],
        message: json["message"],
        timeStamp: json["timeStamp"] == null
            ? null
            : DateTime.parse(json["timeStamp"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "message": message,
        "timeStamp": timeStamp?.toIso8601String(),
        "_id": id,
      };
}

class SenderId {
  List<dynamic>? rewards;
  Map<String, dynamic>? id;
  Map<String, dynamic>? completeName;
  int? employeeNumber;
  Map<String, dynamic>? password;
  Map<String, dynamic>? role;
  DateTime? createdAt;
  int? accountNumber;
  int? accountHolder;
  Map<String, dynamic>? email;
  bool? isActive;
  int? seats;
  Map<String, dynamic>? planType;
  int? monthlyPoints;
  Map<String, dynamic>? accountType;
  Map<String, dynamic>? companyName;
  int? v;
  String? avatar;
  int? giftedPoints;
  int? pointsReceived;
  bool? visible;

  SenderId({
    this.rewards,
    this.id,
    this.completeName,
    this.employeeNumber,
    this.password,
    this.role,
    this.createdAt,
    this.accountNumber,
    this.accountHolder,
    this.email,
    this.isActive,
    this.seats,
    this.planType,
    this.monthlyPoints,
    this.accountType,
    this.companyName,
    this.v,
    this.avatar,
    this.giftedPoints,
    this.pointsReceived,
    this.visible,
  });

  factory SenderId.fromJson(Map<String, dynamic> json) => SenderId(
        rewards: json["rewards"] == null
            ? []
            : List<dynamic>.from(json["rewards"]!.map((x) => x)),
        id: json["_id"],
        completeName: json["completeName"],
        employeeNumber: json["employeeNumber"],
        password: json["password"],
        role: json["role"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        accountNumber: json["accountNumber"],
        accountHolder: json["accountHolder"],
        email: json["email"],
        isActive: json["isActive"],
        seats: json["seats"],
        planType: json["planType"],
        monthlyPoints: json["monthlyPoints"],
        accountType: json["accountType"],
        companyName: json["companyName"],
        v: json["__v"],
        avatar: json["avatar"],
        giftedPoints: json["giftedPoints"],
        pointsReceived: json["pointsReceived"],
        visible: json["visible"],
      );

  Map<String, dynamic> toJson() => {
        "rewards":
            rewards == null ? [] : List<dynamic>.from(rewards!.map((x) => x)),
        "_id": id,
        "completeName": completeName,
        "employeeNumber": employeeNumber,
        "password": password,
        "role": role,
        "createdAt": createdAt?.toIso8601String(),
        "accountNumber": accountNumber,
        "accountHolder": accountHolder,
        "email": email,
        "isActive": isActive,
        "seats": seats,
        "planType": planType,
        "monthlyPoints": monthlyPoints,
        "accountType": accountType,
        "companyName": companyName,
        "__v": v,
        "avatar": avatar,
        "giftedPoints": giftedPoints,
        "pointsReceived": pointsReceived,
        "visible": visible,
      };
}

class Like {
  String? id;

  Like({
    this.id,
  });

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
      };
}
