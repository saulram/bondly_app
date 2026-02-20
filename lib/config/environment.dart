import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static const String baseUrl = "https://api.bondly.mx/api/";
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
}