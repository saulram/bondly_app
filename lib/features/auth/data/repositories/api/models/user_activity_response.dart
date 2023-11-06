class PaginatedUserActivityResponse {
  late bool success;
  late int count;
  late int nextPage;
  late int prevPage;
  late List<UserActivityResponse> data;

  PaginatedUserActivityResponse({
    required this.success,
    required this.count,
    required this.nextPage,
    required this.prevPage,
    required this.data
  });

  PaginatedUserActivityResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    count = json['count'] ?? 0;
    nextPage = json['next'] ?? -1;
    prevPage = json['prev'] ?? -1;
    data = <UserActivityResponse>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(UserActivityResponse.fromJson(v));
      });
    }
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
  late String id;
  late String userId;
  late String feedId;
  late String title;
  late String content;
  late bool read;
  late String createdAt;
  late String updatedAt;
  late String type;

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

  UserActivityResponse.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? "";
    userId = json['user_id'] ?? "";
    feedId = json['feed_id'] ?? "";
    title = json['title'] ?? "";
    content = json['content'] ?? "";
    read = json['read'] ?? false;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    type = json['type'] ?? "";
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