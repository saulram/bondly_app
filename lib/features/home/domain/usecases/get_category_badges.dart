import 'package:bondly_app/features/home/domain/models/category_badges.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetCategoryBadgesUseCase {
  final CompanyFeedsRepository repository;

  GetCategoryBadgesUseCase(this.repository);

  Future<Result<Badges, Exception>> invoke(String categoryId) async {
    return await repository.getBadges(categoryId);
  }
}
