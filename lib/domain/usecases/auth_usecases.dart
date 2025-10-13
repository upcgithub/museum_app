import 'package:museum_app/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUseCases {
  final AuthRepository _authRepository;

  AuthUseCases(this._authRepository);

  // Stream para cambios de estado
  Stream<AuthState> get authStateChanges => _authRepository.authStateChanges;

  // Verificaciones
  User? get currentUser => _authRepository.currentUser;
  bool get isAuthenticated => _authRepository.isAuthenticated;

  // Caso de uso: Login con email y contraseña
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (email.trim().isEmpty) {
        return AuthResult.failure('El email no puede estar vacío');
      }
      if (password.trim().isEmpty) {
        return AuthResult.failure('La contraseña no puede estar vacía');
      }
      if (password.length < 6) {
        return AuthResult.failure(
            'La contraseña debe tener al menos 6 caracteres');
      }

      final response = await _authRepository.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return AuthResult.success(response);
    } catch (e) {
      return AuthResult.failure(_handleError(e));
    }
  }

  // Caso de uso: Registro con email y contraseña
  Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (email.trim().isEmpty) {
        return AuthResult.failure('El email no puede estar vacío');
      }
      if (password.trim().isEmpty) {
        return AuthResult.failure('La contraseña no puede estar vacía');
      }
      if (password.length < 6) {
        return AuthResult.failure(
            'La contraseña debe tener al menos 6 caracteres');
      }

      final response = await _authRepository.signUpWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return AuthResult.success(response);
    } catch (e) {
      return AuthResult.failure(_handleError(e));
    }
  }

  // Caso de uso: Login con Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      final response = await _authRepository.signInWithGoogle();
      return AuthResult.success(response);
    } catch (e) {
      return AuthResult.failure(_handleError(e));
    }
  }

  // Caso de uso: Login con Apple
  Future<AuthResult> signInWithApple() async {
    try {
      final response = await _authRepository.signInWithApple();
      return AuthResult.success(response);
    } catch (e) {
      return AuthResult.failure(_handleError(e));
    }
  }

  // Caso de uso: Reset password
  Future<AuthResult> resetPassword(String email) async {
    try {
      if (email.trim().isEmpty) {
        return AuthResult.failure('El email no puede estar vacío');
      }

      await _authRepository.resetPassword(email.trim());
      return AuthResult.success(null);
    } catch (e) {
      return AuthResult.failure(_handleError(e));
    }
  }

  // Caso de uso: Cerrar sesión
  Future<AuthResult> signOut() async {
    try {
      await _authRepository.signOut();
      return AuthResult.success(null);
    } catch (e) {
      return AuthResult.failure(_handleError(e));
    }
  }

  // Caso de uso: Actualizar email
  Future<AuthResult> updateEmail(String newEmail) async {
    try {
      if (newEmail.trim().isEmpty) {
        return AuthResult.failure('El email no puede estar vacío');
      }

      await _authRepository.updateEmail(newEmail.trim());
      return AuthResult.success(null);
    } catch (e) {
      return AuthResult.failure(_handleError(e));
    }
  }

  // Caso de uso: Actualizar contraseña
  Future<AuthResult> updatePassword(String newPassword) async {
    try {
      if (newPassword.trim().isEmpty) {
        return AuthResult.failure('La contraseña no puede estar vacía');
      }
      if (newPassword.length < 6) {
        return AuthResult.failure(
            'La contraseña debe tener al menos 6 caracteres');
      }

      await _authRepository.updatePassword(newPassword);
      return AuthResult.success(null);
    } catch (e) {
      return AuthResult.failure(_handleError(e));
    }
  }

  // Manejar errores de manera amigable
  String _handleError(dynamic error) {
    if (error is String) return error;

    if (error.toString().contains('Invalid login credentials')) {
      return 'Credenciales incorrectas';
    } else if (error.toString().contains('Email not confirmed')) {
      return 'Email no confirmado. Revisa tu correo electrónico';
    } else if (error.toString().contains('User not found')) {
      return 'Usuario no encontrado';
    } else if (error.toString().contains('Email already registered')) {
      return 'Email ya registrado';
    } else if (error
        .toString()
        .contains('Password should be at least 6 characters')) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    return 'Ha ocurrido un error inesperado';
  }
}

// Clase para resultados de autenticación
class AuthResult {
  final bool isSuccess;
  final dynamic data;
  final String? error;

  AuthResult._({
    required this.isSuccess,
    this.data,
    this.error,
  });

  factory AuthResult.success(dynamic data) {
    return AuthResult._(isSuccess: true, data: data);
  }

  factory AuthResult.failure(String error) {
    return AuthResult._(isSuccess: false, error: error);
  }
}
