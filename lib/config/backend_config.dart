enum BackendType { api, supabase }

class BackendConfig {
  static BackendType get current {
    const value = String.fromEnvironment('BACKEND', defaultValue: 'api');
    if (value == 'supabase') return BackendType.supabase;
    return BackendType.api;
  }

  static bool get isSupabase => current == BackendType.supabase;
  static bool get isApi => current == BackendType.api;
}
