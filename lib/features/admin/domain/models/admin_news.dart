class AdminNews {
  final String id;
  final String? title;
  final String? content;
  final String? image;
  final bool hidden;
  final DateTime? createdAt;

  const AdminNews({
    required this.id,
    this.title,
    this.content,
    this.image,
    required this.hidden,
    this.createdAt,
  });

  factory AdminNews.fromJson(Map<String, dynamic> json) {
    return AdminNews(
      id: json['id'] as String,
      title: json['title'] as String?,
      content: json['content'] as String?,
      image: json['image'] as String?,
      hidden: json['hidden'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  AdminNews copyWith({bool? hidden}) => AdminNews(
        id: id,
        title: title,
        content: content,
        image: image,
        hidden: hidden ?? this.hidden,
        createdAt: createdAt,
      );
}
