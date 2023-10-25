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
  late String userId;
  late String title;
  late String content;
  late bool read;
  late String createdAt;
  late String updatedAt;
  late String type;

  UserActivityResponse({
    required this.userId,
    required this.title,
    required this.content,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
  });

  UserActivityResponse.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ?? "";
    title = json['title'] ?? "";
    content = json['content'] ?? "";
    read = json['read'] ?? false;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    type = json['type'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['title'] = title;
    data['content'] = content;
    data['read'] = read;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['type'] = type;
    return data;
  }
}