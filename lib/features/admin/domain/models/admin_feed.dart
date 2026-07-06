class AdminFeed {
  final String id;
  final String? header;
  final String? body;
  final String? image;
  final String? type;
  final String? senderName;
  final bool visible;
  final bool isHighlighted;
  final DateTime? createdAt;

  AdminFeed({
    required this.id,
    this.header,
    this.body,
    this.image,
    this.type,
    this.senderName,
    required this.visible,
    required this.isHighlighted,
    this.createdAt,
  });

  factory AdminFeed.fromJson(Map<String, dynamic> json) {
    return AdminFeed(
      id: json['id'] as String,
      header: json['header'] as String?,
      body: json['body'] as String?,
      image: json['image'] as String?,
      type: json['type'] as String?,
      senderName:
          (json['users'] as Map<String, dynamic>?)?['complete_name'] as String?,
      visible: json['visible'] as bool? ?? true,
      isHighlighted: json['is_highlighted'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}

class AdminFeedComment {
  final String id;
  final String message;
  final String? userName;
  final DateTime? createdAt;

  AdminFeedComment({
    required this.id,
    required this.message,
    this.userName,
    this.createdAt,
  });

  factory AdminFeedComment.fromJson(Map<String, dynamic> json) {
    return AdminFeedComment(
      id: json['id'] as String,
      message: json['message'] as String? ?? '',
      userName:
          (json['users'] as Map<String, dynamic>?)?['complete_name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
