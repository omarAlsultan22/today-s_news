import 'package:flutter/material.dart';
import '../../data/datasources/local/cacheHelper.dart';


class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeNotifier() {
    _loadTheme();
  }

  static const key = 'theme';

  Future<void> toggleTheme() async {
    switch (_themeMode) {
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.light;
        break;
      case ThemeMode.system:
        _themeMode = ThemeMode.light;
        break;
    }
    setTheme(_themeMode);
    notifyListeners();
  }

  void _loadTheme() async {
    try {
      String? theme = await CacheHelper.getString(key: key);

      if (theme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (theme == 'light') {
        _themeMode = ThemeMode.light;
      } else if (theme == 'system') {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.system;
        await CacheHelper.setString(key: 'theme', value: 'system');
      }
      notifyListeners();
    } catch (e) {
      print("Error loading theme: $e");
    }
  }

  void setTheme(ThemeMode mode) {
    late String themeValue;
    switch (mode) {
      case ThemeMode.light:
        themeValue = 'light';
        break;
      case ThemeMode.dark:
        themeValue = 'dark';
        break;
      case ThemeMode.system:
        themeValue = 'system';
        break;
    }

    CacheHelper.setString(key: key, value: themeValue);
    notifyListeners();
  }
}







