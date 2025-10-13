import 'package:flutter/material.dart';
import 'package:museum_app/presentation/providers/auth_provider.dart';

class RegisterProvider extends ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  String? _error;

  // Getters
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get acceptTerms => _acceptTerms;
  String? get error => _error;

  // Validaciones
  bool get canSubmit =>
      _firstName.trim().isNotEmpty &&
      _lastName.trim().isNotEmpty &&
      _isValidEmail(_email) &&
      _password.length >= 6 &&
      _password == _confirmPassword &&
      _acceptTerms;

  // Setters
  void updateFirstName(String value) {
    _firstName = value;
    _clearErrors();
    notifyListeners();
  }

  void updateLastName(String value) {
    _lastName = value;
    _clearErrors();
    notifyListeners();
  }

  void updateEmail(String value) {
    _email = value;
    _clearErrors();
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    _clearErrors();
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    _confirmPassword = value;
    _clearErrors();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void setAcceptTerms(bool value) {
    _acceptTerms = value;
    _clearErrors();
    notifyListeners();
  }

  // Validaciones específicas
  String? get firstNameError {
    if (_firstName.trim().isEmpty) return null;
    if (_firstName.trim().length < 2) return 'First name too short';
    return null;
  }

  String? get lastNameError {
    if (_lastName.trim().isEmpty) return null;
    if (_lastName.trim().length < 2) return 'Last name too short';
    return null;
  }

  String? get emailError {
    if (_email.trim().isEmpty) return null;
    if (!_isValidEmail(_email)) return 'Invalid email format';
    return null;
  }

  String? get passwordError {
    if (_password.isEmpty) return null;
    if (_password.length < 6) return 'Minimum 6 characters';
    return null;
  }

  String? get confirmPasswordError {
    if (_confirmPassword.isEmpty) return null;
    if (_password != _confirmPassword) return 'Passwords do not match';
    return null;
  }

  // Método para registro
  Future<bool> performRegister(AuthProvider authProvider) async {
    // Validaciones finales
    if (!canSubmit) {
      if (_firstName.trim().isEmpty) {
        _error = 'Please enter your first name';
      } else if (_lastName.trim().isEmpty) {
        _error = 'Please enter your last name';
      } else if (!_isValidEmail(_email)) {
        _error = 'Please enter a valid email address';
      } else if (_password.length < 6) {
        _error = 'Password must be at least 6 characters long';
      } else if (_password != _confirmPassword) {
        _error = 'Passwords do not match';
      } else if (!_acceptTerms) {
        _error = 'You must accept the terms and conditions';
      }
      notifyListeners();
      return false;
    }

    _error = null;
    notifyListeners();

    final success = await authProvider.signUpWithEmailAndPassword(
      email: _email.trim(),
      password: _password,
    );

    if (!success) {
      _error =
          authProvider.error ?? 'Error creating account. Please try again.';
      notifyListeners();
    }

    return success;
  }

  // Método para registro con Google
  Future<bool> signUpWithGoogle(AuthProvider authProvider) async {
    _error = null;
    notifyListeners();

    return await authProvider.signInWithGoogle();
  }

  // Método para registro con Apple
  Future<bool> signUpWithApple(AuthProvider authProvider) async {
    _error = null;
    notifyListeners();

    return await authProvider.signInWithApple();
  }

  // Validación de email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _clearErrors() {
    _error = null;
  }

  // Setters para errores (útil para testing o casos especiales)
  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Limpiar todos los campos
  void clearForm() {
    _firstName = '';
    _lastName = '';
    _email = '';
    _password = '';
    _confirmPassword = '';
    _obscurePassword = true;
    _obscureConfirmPassword = true;
    _acceptTerms = false;
    _error = null;
    notifyListeners();
  }
}
