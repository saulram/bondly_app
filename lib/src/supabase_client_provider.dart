import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientProvider {
  final SupabaseClient client;

  SupabaseClientProvider() : client = Supabase.instance.client;
}
