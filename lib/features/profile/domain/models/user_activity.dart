class UserActivityHolder {
  final int count;
  final int nextPage;
  final int prevPage;
  final List<UserActivityItem> activity;

  UserActivityHolder({
    required this.count,
    required this.nextPage,
    required this.prevPage,
    required this.activity
  });
}

class UserActivityItem {
  final String userId;
  final String title;
  final String content;
  final bool read;
  final String createdAt;
  final String updatedAt;
  final String type;

  UserActivityItem({
    required this.userId,
    required this.title,
    required this.content,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
  });
}