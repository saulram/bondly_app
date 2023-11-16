import 'package:bondly_app/features/home/domain/models/company_categories.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetCategoriesUseCase {
  final CompanyFeedsRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Result<Categories, Exception>> invoke() async {
    return await repository.getCategories();
  }
}
