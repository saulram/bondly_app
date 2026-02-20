import 'package:flutter_dotenv/flutter_dotenv.dart';

enum BackendType { api, supabase }

class BackendConfig {
  static BackendType get current {
    final value = dotenv.env['BACKEND']?.toLowerCase();
    if (value == 'supabase') return BackendType.supabase;
    return BackendType.api;
  }

  static bool get isSupabase => current == BackendType.supabase;
  static bool get isApi => current == BackendType.api;
}
