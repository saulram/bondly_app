import 'package:bondly_app/features/ai/domain/models/sentiment_result.dart';
import 'package:bondly_app/features/ai/domain/repositories/ai_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class AnalyzeSentimentUseCase {
  final AIRepository repository;

  AnalyzeSentimentUseCase(this.repository);

  Future<Result<SentimentResult, Exception>> invoke({
    required String text,
  }) async {
    return await repository.analyzeSentiment(text: text);
  }
}
