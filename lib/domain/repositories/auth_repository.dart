import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  // Estado de autenticación
  Stream<AuthState> get authStateChanges;
  User? get currentUser;
  bool get isAuthenticated;

  // Métodos de autenticación
  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthResponse> signInWithGoogle();
  Future<AuthResponse> signInWithApple();
  Future<void> signOut();

  // Gestión de contraseña
  Future<void> resetPassword(String email);

  // Actualización de perfil
  Future<void> updateEmail(String newEmail);
  Future<void> updatePassword(String newPassword);
}
