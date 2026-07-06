import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GeminiService {
  final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  GeminiService();

  Future<Map<String, dynamic>> generateJsonResponse(String prompt) async {
    try {
      _log.i('Gemini request initiated (via Edge Function)');

      // Explicitly attach the session token. The Edge Function requires an
      // Authorization header (verify_jwt=false + its own getUser check), and
      // relying on the client's implicit header has proven flaky on web.
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        throw GeminiServiceException('No active session for Gemini request');
      }

      final response = await Supabase.instance.client.functions.invoke(
        'gemini',
        body: {'prompt': prompt},
        headers: {'Authorization': 'Bearer ${session.accessToken}'},
      );

      final dynamic data = response.data;
      if (data == null) {
        throw GeminiServiceException(
            'Empty response from Gemini Edge Function');
      }

      _log.i('Gemini response received');

      // The edge function should return JSON parsed by the supabase client
      // If it returned a raw string, we might need to jsonDecode.
      // Let's handle both cases.
      if (data is Map<String, dynamic>) {
        return data;
      } else if (data is String) {
        return json.decode(data) as Map<String, dynamic>;
      } else {
        throw GeminiServiceException(
            'Unexpected response format from Gemini Edge Function');
      }
    } on FunctionException catch (e) {
      _log.e('Supabase Edge Function error: ${e.toString()}');
      throw GeminiServiceException('Edge Function error: ${e.toString()}');
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
