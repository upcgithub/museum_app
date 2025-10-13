import 'dart:math';

import 'package:flutter/material.dart';
import 'package:museum_app/presentation/providers/auth_provider.dart';

class LoginProvider extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String? _error;
  final List<String> _captchaSequence = const ['museum', 'palette', 'theater'];
  late List<String> _captchaOptions;
  final List<String> _selectedCaptcha = [];
  bool _captchaError = false;
  final Random _random = Random();

  String get email => _email;
  String get password => _password;
  bool get rememberMe => _rememberMe;
  bool get obscurePassword => _obscurePassword;
  String? get error => _error;
  bool get isLoading => false; // El loading se maneja en AuthProvider
  bool get canSubmit => _credentialsAreValid;
  List<String> get captchaSequence => List.unmodifiable(_captchaSequence);
  List<String> get captchaOptions => List.unmodifiable(_captchaOptions);
  List<String> get selectedCaptcha => List.unmodifiable(_selectedCaptcha);
  bool get showCaptchaError => _captchaError;
  bool get captchaSolved =>
      _selectedCaptcha.length == _captchaSequence.length && !_captchaError;

  LoginProvider() {
    _generateCaptchaOptions();
  }

  void updateEmail(String value) {
    if (_email == value) return;
    _email = value;
    _clearErrors();
    notifyListeners();
  }

  void updatePassword(String value) {
    if (_password == value) return;
    _password = value;
    _clearErrors();
    notifyListeners();
  }

  void setRememberMe(bool value) {
    if (_rememberMe == value) return;
    _rememberMe = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void selectCaptchaItem(String id) {
    if (captchaSolved || _selectedCaptcha.contains(id)) {
      return;
    }

    _captchaError = false;

    final expectedId = _captchaSequence[_selectedCaptcha.length];

    if (id == expectedId) {
      _selectedCaptcha.add(id);
    } else {
      _selectedCaptcha..clear();
      _captchaError = true;
    }

    notifyListeners();
  }

  void resetCaptcha() {
    _selectedCaptcha.clear();
    _captchaError = false;
    _generateCaptchaOptions();
    notifyListeners();
  }

  bool isCaptchaOptionSelected(String id) => _selectedCaptcha.contains(id);

  bool isCaptchaOptionEnabled(String id) =>
      !captchaSolved && !isCaptchaOptionSelected(id);

  Future<bool> login() async {
    if (!_credentialsAreValid) return false;

    _error = null;
    notifyListeners();

    // Obtener el AuthProvider del contexto
    // Nota: Este método será llamado desde un widget que tiene acceso al AuthProvider
    return true; // El login real se hará en el widget usando AuthProvider
  }

  // Método para realizar login usando AuthProvider
  Future<bool> performLoginWithAuthProvider(AuthProvider authProvider) async {
    if (!_credentialsAreValid) return false;

    _error = null;
    notifyListeners();

    final success = await authProvider.signInWithEmailAndPassword(
      email: _email.trim(),
      password: _password,
    );

    // Si falla, el error estará en authProvider.error
    return success;
  }

  // Método para login con Google
  Future<bool> signInWithGoogle(AuthProvider authProvider) async {
    _error = null;
    notifyListeners();

    return await authProvider.signInWithGoogle();
  }

  // Método para login con Apple
  Future<bool> signInWithApple(AuthProvider authProvider) async {
    _error = null;
    notifyListeners();

    return await authProvider.signInWithApple();
  }

  // Método para reset password
  Future<bool> resetPassword(AuthProvider authProvider) async {
    if (!_isValidEmail(_email)) {
      _error = 'Por favor ingresa un email válido';
      notifyListeners();
      return false;
    }

    return await authProvider.resetPassword(_email.trim());
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

  void _generateCaptchaOptions() {
    _captchaOptions = List<String>.from(_captchaSequence)..shuffle(_random);
  }

  bool get _credentialsAreValid =>
      _email.trim().isNotEmpty &&
      _password.trim().isNotEmpty &&
      _isValidEmail(_email) &&
      _password.length >= 6;
}
