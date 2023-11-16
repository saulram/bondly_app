import 'package:bondly_app/features/home/domain/models/announcement_model.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetCompanyAnnouncementsUseCase {
  final CompanyFeedsRepository repository;

  GetCompanyAnnouncementsUseCase(this.repository);

  Future<Result<Announcements, Exception>> invoke() async {
    return await repository.getCompanyAnnouncements();
  }
}
