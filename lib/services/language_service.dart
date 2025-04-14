import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  static const String _defaultLanguage = 'en';

  String _currentLanguage = _defaultLanguage;
  final SharedPreferences _prefs;

  LanguageService(this._prefs) {
    _loadLanguage();
  }

  String get currentLanguage => _currentLanguage;

  Future<void> _loadLanguage() async {
    _currentLanguage = _prefs.getString(_languageKey) ?? _defaultLanguage;
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    if (_currentLanguage != languageCode) {
      _currentLanguage = languageCode;
      await _prefs.setString(_languageKey, languageCode);
      notifyListeners();
    }
  }

  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
    'pt': 'Português',
    'ru': 'Русский',
    'zh': '中文',
    'ja': '日本語',
    'ko': '한국어',
  };
}
