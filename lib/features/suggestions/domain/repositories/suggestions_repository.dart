import 'package:bondly_app/features/suggestions/domain/models/suggestion.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class SuggestionsRepository {
  /// Submits a new suggestion. When [anonymous] is true no author is stored.
  Future<Result<void, Exception>> submit({
    required String message,
    String? title,
    String? category,
    required bool anonymous,
  });

  /// The current user's own (non-anonymous) suggestions.
  Future<Result<List<Suggestion>, Exception>> getMine();
}

class SuggestionException implements Exception {
  final String message;
  SuggestionException([this.message = 'Error con la sugerencia']);

  @override
  String toString() => message;
}
