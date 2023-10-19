import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:multiple_result/multiple_result.dart';

class CreateFeedCommentUseCase {
  final CompanyFeedsRepository repository;

  CreateFeedCommentUseCase(this.repository);

  Future<Result<FeedData, Exception>> invoke(
      String postId, String message) async {
    return await repository.createComment(postId, message);
  }
}
