class UserActivityHolder {
  final int count;
  final int nextPage;
  final int prevPage;
  final List<UserActivityItem> activity;

  UserActivityHolder(
      {required this.count,
      required this.nextPage,
      required this.prevPage,
      required this.activity});
}

class UserActivityItem {
  final String id;
  final String userId;
  final String feedId;
  final String title;
  final String content;
  bool read = false;
  final String createdAt;
  final String updatedAt;
  final String type;

  UserActivityItem({
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

  factory UserActivityItem.fromSupabase(Map<String, dynamic> json) {
    final title = json['title'] as String? ?? '';
    return UserActivityItem(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      feedId: json['feed_id'] ?? '',
      title: title,
      content: json['content'] ?? '',
      read: json['read'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      type: _typeFromTitle(title),
    );
  }

  static String _typeFromTitle(String title) {
    if (title.contains('reconocimiento') || title.contains('Reconocimiento')) {
      return 'Reconocimientos';
    } else if (title.contains('canje') || title.contains('Canje') || title.contains('recompensa')) {
      return 'Recompensas';
    } else if (title.contains('embajada') || title.contains('embajador')) {
      return 'Embajadas';
    } else if (title.contains('gusta') || title.contains('like')) {
      return 'Me Gusta';
    } else if (title.contains('comentario') || title.contains('comentaron')) {
      return 'Comentario nuevo';
    }
    return title;
  }
}
