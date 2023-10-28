import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:multiple_result/multiple_result.dart';

class CreateAcknowledgmentUseCase {
  final CompanyFeedsRepository repository;

  CreateAcknowledgmentUseCase(this.repository);

  Future<Result<bool, Exception>> invoke(
      String badgeId, String message, List<String> recipients) async {
    return await repository.createAcknowledgment(badgeId, message, recipients);
  }
}
