class SingleActivityResponse {
  late final String id;
  late final String userId;
  late final String title;
  late final String content;
  late final bool read;
  late final String feedId;
  late final String createdAt;
  late final String updatedAt;

  SingleActivityResponse({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.read,
    required this.feedId,
    required this.createdAt,
    required this.updatedAt,
  });

  SingleActivityResponse.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    userId = json['user_id'];
    title = json['title'];
    content = json['content'];
    read = json['read'];
    feedId = json['feed_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['content'] = content;
    data['read'] = read;
    data['feed_id'] = feedId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
