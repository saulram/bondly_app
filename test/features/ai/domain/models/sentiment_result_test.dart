import 'package:bondly_app/features/ai/domain/models/sentiment_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SentimentResult', () {
    test('fromValues creates positive sentiment', () {
      final result = SentimentResult.fromValues(
        sentimentLabel: 'positive',
        confidence: 0.95,
        summary: 'Muy positivo',
      );

      expect(result.sentiment, SentimentType.positive);
      expect(result.confidence, 0.95);
      expect(result.summary, 'Muy positivo');
    });

    test('fromValues creates negative sentiment', () {
      final result = SentimentResult.fromValues(
        sentimentLabel: 'negative',
        confidence: 0.8,
        summary: 'Sentimiento negativo detectado',
      );

      expect(result.sentiment, SentimentType.negative);
      expect(result.confidence, 0.8);
      expect(result.summary, 'Sentimiento negativo detectado');
    });

    test('fromValues creates neutral sentiment', () {
      final result = SentimentResult.fromValues(
        sentimentLabel: 'neutral',
        confidence: 0.6,
        summary: 'Sin sentimiento claro',
      );

      expect(result.sentiment, SentimentType.neutral);
      expect(result.confidence, 0.6);
    });

    test('fromValues defaults to neutral for unknown labels', () {
      final result = SentimentResult.fromValues(
        sentimentLabel: 'unknown_label',
        confidence: 0.5,
        summary: 'test',
      );

      expect(result.sentiment, SentimentType.neutral);
    });

    test('fromValues handles case-insensitive labels', () {
      final positiveUpper = SentimentResult.fromValues(
        sentimentLabel: 'POSITIVE',
        confidence: 0.9,
        summary: 'test',
      );
      expect(positiveUpper.sentiment, SentimentType.positive);

      final negativeMixed = SentimentResult.fromValues(
        sentimentLabel: 'Negative',
        confidence: 0.9,
        summary: 'test',
      );
      expect(negativeMixed.sentiment, SentimentType.negative);
    });

    test('fromValues handles empty label as neutral', () {
      final result = SentimentResult.fromValues(
        sentimentLabel: '',
        confidence: 0.0,
        summary: '',
      );

      expect(result.sentiment, SentimentType.neutral);
    });

    test('constructor creates instance directly', () {
      final result = SentimentResult(
        sentiment: SentimentType.positive,
        confidence: 0.99,
        summary: 'Excellent',
      );

      expect(result.sentiment, SentimentType.positive);
      expect(result.confidence, 0.99);
      expect(result.summary, 'Excellent');
    });
  });

  group('SentimentType', () {
    test('has all expected values', () {
      expect(SentimentType.values, hasLength(3));
      expect(SentimentType.values, contains(SentimentType.positive));
      expect(SentimentType.values, contains(SentimentType.neutral));
      expect(SentimentType.values, contains(SentimentType.negative));
    });
  });
}
