import 'package:bondly_app/features/auth/data/repositories/api/models/user_activity_response.dart';
import 'package:bondly_app/features/profile/domain/models/user_activity.dart';

class UserActivityResponseMapper {
  UserActivityHolder map(PaginatedUserActivityResponse from) {
    var activity = from.data.map(
      (e) => UserActivityItem(
        userId: e.userId,
        title: e.title,
        content: e.content,
        read: e.read,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
        type: e.type,
      )
    ).toList();

    return UserActivityHolder(
        count: from.count,
        nextPage: from.nextPage,
        prevPage: from.prevPage,
        activity: activity
    );
  }
}