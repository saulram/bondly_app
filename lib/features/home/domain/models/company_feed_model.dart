class CompanyFeed {
  final bool success;
  final List<FeedData> data;

  CompanyFeed({required this.success, required this.data});

  factory CompanyFeed.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    //sort dataList for createdAt
    List<FeedData> feedDataList =
        dataList.map((feed) => FeedData.fromJson(feed)).toList();

    return CompanyFeed(success: json['success'], data: feedDataList);
  }
}

class FeedData {
  final String? id;
  final int account;
  final String header;
  final String body;
  final String? footer;
  final Sender sender;
  final String type;
  final Badge? badge;
  final List<Comment> comments;
  final List<Like> likes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final bool visible;
  final bool? isLiked;
  final String? image;

  FeedData(
      {required this.id,
      required this.account,
      required this.header,
      required this.body,
      required this.footer,
      required this.sender,
      required this.type,
      this.badge,
      required this.comments,
      required this.likes,
      required this.createdAt,
      required this.updatedAt,
      required this.v,
      required this.visible,
      this.image,
      this.isLiked});

  factory FeedData.fromJson(Map<String, dynamic> json) {
    var commentsList = json['comments'] as List;
    List<Comment> comments =
        commentsList.map((comment) => Comment.fromJson(comment)).toList();

    var likesList = json['likes'] as List;
    List<Like> likes = likesList.map((like) => Like.fromJson(like)).toList();

    Badge? badge;
    if (json['badge_id'] != null) {
      badge = Badge.fromJson(json['badge_id']);
    }

    return FeedData(
        id: json['_id'],
        account: json['account'],
        header: json['header'],
        body: json['body'],
        footer: json['footer'],
        sender: Sender.fromJson(json['sender_id']),
        type: json['type'],
        badge: badge,
        comments: comments,
        likes: likes,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
        v: json['__v'],
        visible: json['visible'],
        isLiked: json['userLike'] ?? false,
        image: json['image']);
  }
}

class Sender {
  final String id;
  final String completeName;
  final int employeeNumber;
  final String? role;
  final String? createdAt;
  final int? accountNumber;
  final int? accountHolder;
  final String email;
  final bool isActive;
  final int seats;
  final String? planType;
  final int monthlyPoints;
  final String? accountType;
  final String? companyName;
  final int giftedPoints;
  final int pointsReceived;
  final bool visible;
  final String? avatar;

  Sender({
    required this.id,
    required this.completeName,
    required this.employeeNumber,
    required this.role,
    required this.createdAt,
    required this.accountNumber,
    this.accountHolder,
    required this.email,
    required this.isActive,
    required this.seats,
    required this.planType,
    required this.monthlyPoints,
    required this.accountType,
    required this.companyName,
    required this.giftedPoints,
    required this.pointsReceived,
    required this.visible,
    required this.avatar,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['_id'],
      completeName: json['completeName'],
      employeeNumber: json['employeeNumber'],
      role: json['role'],
      createdAt: json['createdAt'],
      accountNumber: json['accountNumber'],
      accountHolder: json['accountHolder'],
      email: json['email'],
      isActive: json['isActive'],
      seats: json['seats'],
      planType: json['planType'],
      monthlyPoints: json['monthlyPoints'],
      accountType: json['accountType'],
      companyName: json['companyName'],
      giftedPoints: json['giftedPoints'],
      pointsReceived: json['pointsReceived'],
      visible: json['visible'],
      avatar: json['avatar'],
    );
  }
}

class Badge {
  final String? id;
  final String? categoryId;
  final String? name;
  final String? image;
  final int value;
  final bool isActive;
  final int v;
  final bool visible;

  Badge({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.image,
    required this.value,
    required this.isActive,
    required this.v,
    required this.visible,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['_id'],
      categoryId: json['category_id'],
      name: json['name'],
      image: json['image'],
      value: json['value'],
      isActive: json['isActive'],
      v: json['__v'],
      visible: json['visible'],
    );
  }
}

class Comment {
  final Sender user;
  final String? message;
  final String? timeStamp;
  final String? id;

  Comment({
    required this.user,
    required this.message,
    required this.timeStamp,
    required this.id,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: Sender.fromJson(json['user_id']),
      message: json['message'],
      timeStamp: json['timeStamp'],
      id: json['_id'],
    );
  }
}

class Like {
  final String? id;

  Like({required this.id});

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['_id'],
    );
  }
}
