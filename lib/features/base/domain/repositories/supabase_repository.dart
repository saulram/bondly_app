import 'package:multiple_result/multiple_result.dart';

class SupabaseQueryException implements Exception {
  final String message;
  SupabaseQueryException(this.message);
}

abstract class SupabaseRepository {
  Future<Result<List<Map<String, dynamic>>, Exception>> getAll(String table);

  Future<Result<Map<String, dynamic>, Exception>> getById(
    String table,
    String id,
  );

  Future<Result<List<Map<String, dynamic>>, Exception>> query(
    String table, {
    Map<String, dynamic>? filters,
  });

  Future<Result<Map<String, dynamic>, Exception>> insert(
    String table,
    Map<String, dynamic> data,
  );

  Future<Result<Map<String, dynamic>, Exception>> update(
    String table,
    String id,
    Map<String, dynamic> data,
  );

  Future<Result<void, Exception>> delete(String table, String id);
}
