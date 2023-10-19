import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:multiple_result/multiple_result.dart';

class HandleLikesUseCase {
  final CompanyFeedsRepository repository;

  HandleLikesUseCase(this.repository);

  Future<Result<bool, Exception>> invoke(String postId) async {
    return await repository.likePost(postId);
  }
}
