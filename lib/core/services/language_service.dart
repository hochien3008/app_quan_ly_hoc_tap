import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  Locale _currentLocale = const Locale('vi', 'VN'); // Default to Vietnamese

  Locale get currentLocale => _currentLocale;

  // Get available languages
  List<Map<String, String>> get availableLanguages => [
    {'code': 'vi', 'name': 'Tiếng Việt', 'nativeName': 'Tiếng Việt'},
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
  ];

  LanguageService() {
    _loadSavedLanguage();
  }

  // Load saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);

      if (languageCode != null) {
        _currentLocale = Locale(languageCode);
        notifyListeners();
      }
    } catch (e) {
      // If error, keep default language
      debugPrint('Error loading saved language: $e');
    }
  }

  // Change language
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) return;

    _currentLocale = Locale(languageCode);

    // Save to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      debugPrint('Error saving language: $e');
    }

    notifyListeners();
  }

  // Get current language name
  String getCurrentLanguageName() {
    final language = availableLanguages.firstWhere(
      (lang) => lang['code'] == _currentLocale.languageCode,
      orElse: () => availableLanguages.first,
    );
    return language['nativeName'] ?? language['name'] ?? 'Unknown';
  }

  // Check if current language is Vietnamese
  bool get isVietnamese => _currentLocale.languageCode == 'vi';

  // Check if current language is English
  bool get isEnglish => _currentLocale.languageCode == 'en';
}
