class Environment {
  static const String baseUrl = "https://api.bondly.mx/api/";
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
}