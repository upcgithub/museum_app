import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:museum_app/core/services/supabase_keys.dart';

class SupabaseConfig {
  static const String supabaseUrl = SupabaseKeys.supabaseUrl;
  static const String supabaseAnonKey = SupabaseKeys.supabaseAnonKey;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
