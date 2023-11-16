abstract class SessionTokenHandler {
  void save(String token);
  String? get();
  void clear();
}