import 'package:bondly_app/features/suggestions/domain/models/suggestion.dart';
import 'package:bondly_app/features/suggestions/domain/repositories/suggestions_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetMySuggestionsUseCase {
  final SuggestionsRepository repository;

  GetMySuggestionsUseCase(this.repository);

  Future<Result<List<Suggestion>, Exception>> invoke() async {
    return repository.getMine();
  }
}
