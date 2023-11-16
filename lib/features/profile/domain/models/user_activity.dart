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
}