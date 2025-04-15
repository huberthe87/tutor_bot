import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:amplify_flutter/amplify_flutter.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  static const String _defaultLanguage = 'zh';

  String _currentLanguage = _defaultLanguage;
  final SharedPreferences _prefs;

  LanguageService(this._prefs) {
    _loadLanguage();
  }

  String get currentLanguage => _currentLanguage;

  Future<void> _loadLanguage() async {
    // Get the user-selected language from preferences
    final userLanguage = _prefs.getString(_languageKey);

    debugPrint(
        'LanguageService: Loading language from preferences: $userLanguage');

    if (userLanguage != null) {
      // Use user-selected language if it exists
      _currentLanguage = userLanguage;
      debugPrint(
          'LanguageService: Using user-selected language: $_currentLanguage');
    } else {
      // Always use Chinese as default
      _currentLanguage = 'zh';
      debugPrint(
          'LanguageService: Using hard-coded Chinese language: $_currentLanguage');
    }

    // Track language change in analytics
    await _trackLanguageChange();

    notifyListeners();
  }

  Future<void> _trackLanguageChange() async {
    try {
      // Create an analytics event for language change
      final event = AnalyticsEvent('LanguageChanged');

      // Record the event
      await Amplify.Analytics.recordEvent(event: event);
      debugPrint(
          'LanguageService: Tracked language change in analytics: $_currentLanguage');
    } catch (e) {
      debugPrint('LanguageService: Error tracking language change: $e');
    }
  }

  Future<void> setLanguage(String languageCode) async {
    debugPrint('LanguageService: Setting language to: $languageCode');
    if (_currentLanguage != languageCode) {
      debugPrint(
          'LanguageService: Language is changing from $_currentLanguage to $languageCode');
      _currentLanguage = languageCode;
      await _prefs.setString(_languageKey, languageCode);
      debugPrint(
          'LanguageService: Language saved to preferences: $languageCode');

      // Track language change in analytics
      await _trackLanguageChange();

      debugPrint('LanguageService: Notifying listeners of language change');
      notifyListeners();
      debugPrint('LanguageService: Listeners notified');
    } else {
      debugPrint('LanguageService: Language already set to: $languageCode');
    }
  }

  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'zh': '中文',
  };
}
