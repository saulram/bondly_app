import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetCompanyFeedsUseCase {
  final CompanyFeedsRepository repository;

  GetCompanyFeedsUseCase(this.repository);

  Future<Result<CompanyFeed, Exception>> invoke() async {
    return await repository.getCompanyFeeds();
  }
}
