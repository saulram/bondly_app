import 'package:bondly_app/features/ai/domain/models/sentiment_result.dart';
import 'package:bondly_app/features/ai/domain/repositories/ai_repository.dart';
import 'package:bondly_app/features/ai/domain/usecases/analyze_sentiment_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockAIRepository extends Mock implements AIRepository {}

void main() {
  late AnalyzeSentimentUseCase useCase;
  late MockAIRepository mockRepository;

  setUp(() {
    mockRepository = MockAIRepository();
    useCase = AnalyzeSentimentUseCase(mockRepository);
  });

  group('AnalyzeSentimentUseCase', () {
    test('returns positive sentiment result on success', () async {
      final expectedResult = SentimentResult(
        sentiment: SentimentType.positive,
        confidence: 0.92,
        summary: 'Mensaje muy positivo',
      );

      when(() => mockRepository.analyzeSentiment(
            text: any(named: 'text'),
          )).thenAnswer((_) async => Result.success(expectedResult));

      final result = await useCase.invoke(text: 'Excelente trabajo!');

      result.when(
        (success) {
          expect(success.sentiment, SentimentType.positive);
          expect(success.confidence, 0.92);
          expect(success.summary, 'Mensaje muy positivo');
        },
        (error) => fail('Expected success but got error: $error'),
      );

      verify(() => mockRepository.analyzeSentiment(
            text: 'Excelente trabajo!',
          )).called(1);
    });

    test('returns negative sentiment result', () async {
      final expectedResult = SentimentResult(
        sentiment: SentimentType.negative,
        confidence: 0.85,
        summary: 'Tono negativo detectado',
      );

      when(() => mockRepository.analyzeSentiment(
            text: any(named: 'text'),
          )).thenAnswer((_) async => Result.success(expectedResult));

      final result = await useCase.invoke(text: 'Esto es terrible');

      result.when(
        (success) {
          expect(success.sentiment, SentimentType.negative);
          expect(success.confidence, 0.85);
        },
        (error) => fail('Expected success but got error: $error'),
      );
    });

    test('returns neutral sentiment result', () async {
      final expectedResult = SentimentResult(
        sentiment: SentimentType.neutral,
        confidence: 0.6,
        summary: 'Sentimiento neutral',
      );

      when(() => mockRepository.analyzeSentiment(
            text: any(named: 'text'),
          )).thenAnswer((_) async => Result.success(expectedResult));

      final result = await useCase.invoke(text: 'El informe fue entregado');

      result.when(
        (success) => expect(success.sentiment, SentimentType.neutral),
        (error) => fail('Expected success but got error: $error'),
      );
    });

    test('returns error when repository fails', () async {
      when(() => mockRepository.analyzeSentiment(
            text: any(named: 'text'),
          )).thenAnswer(
        (_) async => Result.error(Exception('Service unavailable')),
      );

      final result = await useCase.invoke(text: 'Test text');

      result.when(
        (success) => fail('Expected error but got success'),
        (error) => expect(error, isA<Exception>()),
      );
    });

    test('passes exact text to repository', () async {
      when(() => mockRepository.analyzeSentiment(
            text: any(named: 'text'),
          )).thenAnswer(
        (_) async => Result.success(SentimentResult(
          sentiment: SentimentType.neutral,
          confidence: 0.5,
          summary: 'test',
        )),
      );

      const testText = 'Un mensaje con emojis 🎉 y caracteres especiales!';
      await useCase.invoke(text: testText);

      verify(() => mockRepository.analyzeSentiment(text: testText)).called(1);
    });
  });
}
