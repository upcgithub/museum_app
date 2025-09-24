import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(_languageKey);

    if (savedLanguageCode != null) {
      // Si el usuario ya seleccionó un idioma manualmente, usar ese
      _currentLocale = Locale(savedLanguageCode);
    } else {
      // Si no hay idioma guardado, usar el idioma del dispositivo
      final deviceLocale = ui.PlatformDispatcher.instance.locale;
      final supportedLanguages = ['en', 'es'];

      if (supportedLanguages.contains(deviceLocale.languageCode)) {
        _currentLocale = Locale(deviceLocale.languageCode);
      } else {
        // Si el idioma del dispositivo no está soportado, usar inglés como fallback
        _currentLocale = const Locale('en');
      }
    }

    notifyListeners();
  }

  Future<void> setLanguage(Locale locale) async {
    _currentLocale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    notifyListeners();
  }

  bool get isEnglish => _currentLocale.languageCode == 'en';
  bool get isSpanish => _currentLocale.languageCode == 'es';
}
