import 'package:museum_app/core/services/auth_service.dart';
import 'package:museum_app/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Stream<AuthState> get authStateChanges => _authService.authStateChanges;

  @override
  User? get currentUser => _authService.currentUser;

  @override
  bool get isAuthenticated => _authService.isAuthenticated;

  @override
  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _authService.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthResponse> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  @override
  Future<AuthResponse> signInWithApple() async {
    return await _authService.signInWithApple();
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }

  @override
  Future<void> updateEmail(String newEmail) async {
    await _authService.updateEmail(newEmail);
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    await _authService.updatePassword(newPassword);
  }
}
