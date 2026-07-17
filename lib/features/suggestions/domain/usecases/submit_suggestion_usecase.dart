import 'package:bondly_app/features/suggestions/domain/repositories/suggestions_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class SubmitSuggestionUseCase {
  final SuggestionsRepository repository;

  SubmitSuggestionUseCase(this.repository);

  Future<Result<void, Exception>> invoke({
    required String message,
    String? title,
    String? category,
    required bool anonymous,
  }) async {
    return repository.submit(
      message: message,
      title: title,
      category: category,
      anonymous: anonymous,
    );
  }
}
