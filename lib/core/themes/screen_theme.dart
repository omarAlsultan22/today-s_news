import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local/cacheHelper.dart';
import 'package:flutter/material.dart';


class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system;
        break;
      case ThemeMode.system:
        _themeMode = ThemeMode.light;
        break;
    }

    // حفظ القيمة
    String themeValue;
    switch (_themeMode) {
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

    CacheHelper.setDate(key: 'theme', value: themeValue);
    notifyListeners();
  }

  ThemeNotifier() {
    _loadTheme();
  }

  void _loadTheme() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? theme = prefs.getString('theme');

      if (theme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (theme == 'light') {
        _themeMode = ThemeMode.light;
      } else if (theme == 'system') {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.system;
        await CacheHelper.setDate(key: 'theme', value: 'system');
      }

      notifyListeners();
    } catch (e) {
      print("Error loading theme: $e");
    }
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    String themeValue;
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

    CacheHelper.setDate(key: 'theme', value: themeValue);
    notifyListeners();
  }
}







