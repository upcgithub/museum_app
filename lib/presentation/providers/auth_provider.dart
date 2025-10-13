import 'package:flutter/material.dart';
import 'package:museum_app/domain/usecases/auth_usecases.dart';
import 'package:museum_app/core/dependency_injection/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthUseCases _authUseCases = getIt<AuthUseCases>();

  AuthStatus _status = AuthStatus.initial;
  String? _error;
  User? _user;

  AuthStatus get status => _status;
  String? get error => _error;
  User? get user => _user;
  bool get isAuthenticated =>
      _status == AuthStatus.authenticated && _user != null;
  bool get isLoading => _status == AuthStatus.loading;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _status = AuthStatus.loading;
    notifyListeners();

    // Escuchar cambios de estado de autenticación
    _authUseCases.authStateChanges.listen((authState) {
      _handleAuthStateChange(authState);
    });
  }

  void _handleAuthStateChange(AuthState authState) {
    if (authState.event == AuthChangeEvent.signedIn) {
      _user = authState.session?.user;
      _status = AuthStatus.authenticated;
      _error = null;
    } else if (authState.event == AuthChangeEvent.signedOut) {
      _user = null;
      _status = AuthStatus.unauthenticated;
      _error = null;
    } else {
      _user = authState.session?.user;
      _status =
          _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      _error = null;
    }

    notifyListeners();
  }

  // Login con email y contraseña
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    final result = await _authUseCases.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (result.isSuccess) {
      // El estado se actualizará automáticamente a través del stream
      return true;
    } else {
      _status = AuthStatus.unauthenticated;
      _error = result.error;
      notifyListeners();
      return false;
    }
  }

  // Registro con email y contraseña
  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    final result = await _authUseCases.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (result.isSuccess) {
      // El estado se actualizará automáticamente a través del stream
      return true;
    } else {
      _status = AuthStatus.unauthenticated;
      _error = result.error;
      notifyListeners();
      return false;
    }
  }

  // Login con Google
  Future<bool> signInWithGoogle() async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    final result = await _authUseCases.signInWithGoogle();

    if (result.isSuccess) {
      // El estado se actualizará automáticamente a través del stream
      return true;
    } else {
      _status = AuthStatus.unauthenticated;
      _error = result.error;
      notifyListeners();
      return false;
    }
  }

  // Login con Apple
  Future<bool> signInWithApple() async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    final result = await _authUseCases.signInWithApple();

    if (result.isSuccess) {
      // El estado se actualizará automáticamente a través del stream
      return true;
    } else {
      _status = AuthStatus.unauthenticated;
      _error = result.error;
      notifyListeners();
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _error = null;
    notifyListeners();

    final result = await _authUseCases.resetPassword(email);

    if (result.isSuccess) {
      return true;
    } else {
      _error = result.error;
      notifyListeners();
      return false;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    _status = AuthStatus.loading;
    notifyListeners();

    await _authUseCases.signOut();

    // El estado se actualizará automáticamente a través del stream
  }

  // Actualizar email
  Future<bool> updateEmail(String newEmail) async {
    _error = null;
    notifyListeners();

    final result = await _authUseCases.updateEmail(newEmail);

    if (result.isSuccess) {
      return true;
    } else {
      _error = result.error;
      notifyListeners();
      return false;
    }
  }

  // Actualizar contraseña
  Future<bool> updatePassword(String newPassword) async {
    _error = null;
    notifyListeners();

    final result = await _authUseCases.updatePassword(newPassword);

    if (result.isSuccess) {
      return true;
    } else {
      _error = result.error;
      notifyListeners();
      return false;
    }
  }

  // Limpiar errores
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Reset del estado
  void reset() {
    _status = AuthStatus.initial;
    _error = null;
    _user = null;
    notifyListeners();
  }
}
