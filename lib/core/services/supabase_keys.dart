// Supabase Configuration Keys
// Reemplaza estos valores con los de tu proyecto de Supabase
// Puedes obtenerlos desde: https://supabase.com/dashboard/project/YOUR_PROJECT/settings/api

class SupabaseKeys {
  // URL de tu proyecto de Supabase
  static const String supabaseUrl = 'https://nvuxfujtzwpynpvpipkx.supabase.co';

  // Clave anónima de tu proyecto de Supabase
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im52dXhmdWp0endweW5wdnBpcGt4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc3Mzc2NjEsImV4cCI6MjA3MzMxMzY2MX0.GThpQkcRE8lP-WyrORQvSRp515exdUgAtHnlicAgAlo';

  // URLs de redirección para OAuth (deben coincidir con la configuración en Supabase)
  static const String googleRedirectUri = 'culture-connect://login-callback';
  static const String appleRedirectUri = 'culture-connect://login-callback';
  static const String resetPasswordRedirectUri =
      'culture-connect://reset-password-callback';
}
