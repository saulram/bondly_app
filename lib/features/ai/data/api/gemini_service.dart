import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:logger/logger.dart';

class GeminiService {
  final String apiKey;
  late final GenerativeModel _model;
  final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  GeminiService({required this.apiKey}) {
    _model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.4,
        maxOutputTokens: 2048,
        responseMimeType: 'application/json',
      ),
    );
  }

  Future<Map<String, dynamic>> generateJsonResponse(String prompt) async {
    try {
      _log.i('Gemini request initiated');
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw GeminiServiceException('Empty response from Gemini');
      }

      _log.i('Gemini response received');
      return json.decode(text) as Map<String, dynamic>;
    } on GenerativeAIException catch (e) {
      _log.e('Gemini API error: ${e.message}');
      throw GeminiServiceException('Gemini API error: ${e.message}');
    } catch (e) {
      _log.e('Gemini service error: $e');
      throw GeminiServiceException('Failed to process Gemini response: $e');
    }
  }
}

class GeminiServiceException implements Exception {
  final String message;
  GeminiServiceException(this.message);

  @override
  String toString() => 'GeminiServiceException: $message';
}
