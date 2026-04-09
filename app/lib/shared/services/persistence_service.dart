import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PersistenceService {
  static const String _themeKey = 'theme_mode';
  static const String _localeKey = 'locale_code';

  final SharedPreferences _prefs;

  PersistenceService(this._prefs);

  // Theme
  ThemeMode getThemeMode() {
    final value = _prefs.getString(_themeKey);
    if (value == 'light') return ThemeMode.light;
    if (value == 'dark') return ThemeMode.dark;
    return ThemeMode.dark; // Default
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
  }

  // Locale
  String getLocaleCode() {
    return _prefs.getString(_localeKey) ?? 'en';
  }

  Future<void> setLocaleCode(String code) async {
    await _prefs.setString(_localeKey, code);
  }
}
