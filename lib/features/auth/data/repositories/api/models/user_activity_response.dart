class PaginatedUserActivityResponse {
  final bool success;
  final int count;
  final int nextPage;
  final int prevPage;
  final List<UserActivityResponse> data;

  PaginatedUserActivityResponse({
    required this.success,
    required this.count,
    required this.nextPage,
    required this.prevPage,
    required this.data
  });

  factory PaginatedUserActivityResponse.fromJson(Map<String, dynamic> json) {
    var success = json['success'] ?? false;
    var count = json['count'] ?? 0;
    var nextPage = json['next'] ?? -1;
    var prevPage = json['prev'] ?? -1;
    var data = <UserActivityResponse>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(UserActivityResponse.fromJson(v));
      });
    }
    return PaginatedUserActivityResponse(
        success: success,
        count: count,
        nextPage: nextPage,
        prevPage: prevPage,
        data: data
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['count'] = count;
    data['next'] = nextPage;
    data['prev'] = prevPage;
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}

class UserActivityResponse {
  final String id;
  final String userId;
  final String feedId;
  final String title;
  final String content;
  final bool read;
  final String createdAt;
  final String updatedAt;
  final String type;

  UserActivityResponse({
    required this.id,
    required this.userId,
    required this.feedId,
    required this.title,
    required this.content,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
  });

  factory UserActivityResponse.fromJson(Map<String, dynamic> json) {
    return UserActivityResponse(
      id: json['_id'] ?? "",
      userId: json['user_id'] ?? "",
      feedId: json['feed_id'] ?? "",
      title: json['title'] ?? "",
      content: json['content'] ?? "",
      read: json['read'] ?? false,
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      type: json['type'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['feed_id'] = feedId;
    data['title'] = title;
    data['content'] = content;
    data['read'] = read;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['type'] = type;
    return data;
  }
}