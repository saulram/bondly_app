import 'package:bondly_app/features/ai/data/api/gemini_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeminiService', () {
    test('instantiates correctly', () {
      final service = GeminiService();
      expect(service, isNotNull);
    });
  });

  group('GeminiServiceException', () {
    test('creates exception with message', () {
      final exception = GeminiServiceException('Something went wrong');
      expect(exception.message, 'Something went wrong');
    });

    test('toString returns formatted message', () {
      final exception = GeminiServiceException('API error');
      expect(exception.toString(), 'GeminiServiceException: API error');
    });

    test('is an Exception', () {
      final exception = GeminiServiceException('test');
      expect(exception, isA<Exception>());
    });

    test('handles empty message', () {
      final exception = GeminiServiceException('');
      expect(exception.message, '');
      expect(exception.toString(), 'GeminiServiceException: ');
    });

    test('handles message with special characters', () {
      final exception =
          GeminiServiceException('Error: código 400 - "bad request"');
      expect(exception.message, 'Error: código 400 - "bad request"');
    });
  });
}
