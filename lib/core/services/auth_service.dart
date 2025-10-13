import 'package:museum_app/core/services/supabase_config.dart';
import 'package:museum_app/core/services/supabase_keys.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Stream para escuchar cambios de estado de autenticación
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Obtener usuario actual
  User? get currentUser => _supabase.auth.currentUser;

  // Verificar si el usuario está autenticado
  bool get isAuthenticated => currentUser != null;

  // Login con email y password
  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Registro con email y password
  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signUp(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Login con Google
  Future<AuthResponse> signInWithGoogle() async {
    try {
      // TODO: Implement Google login
      /*return await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: SupabaseKeys.googleRedirectUri,
      );*/
      throw UnimplementedError();
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Login con Apple
  Future<AuthResponse> signInWithApple() async {
    try {
      // TODO: Implement Apple login
      /*return await _supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: SupabaseKeys.appleRedirectUri,
      );*/
      throw UnimplementedError();
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: SupabaseKeys.resetPasswordRedirectUri,
      );
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Manejar excepciones de autenticación
  String _handleAuthException(AuthException e) {
    switch (e.message) {
      case 'Invalid login credentials':
        return 'Credenciales incorrectas';
      case 'Email not confirmed':
        return 'Email no confirmado. Revisa tu correo electrónico';
      case 'User not found':
        return 'Usuario no encontrado';
      case 'Email already registered':
        return 'Email ya registrado';
      case 'Password should be at least 6 characters':
        return 'La contraseña debe tener al menos 6 caracteres';
      default:
        return e.message;
    }
  }

  // Actualizar email del usuario
  Future<void> updateEmail(String newEmail) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(email: newEmail),
      );
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Actualizar contraseña del usuario
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
}
