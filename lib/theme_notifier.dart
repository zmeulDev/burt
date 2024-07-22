import 'package:burt/theme.dart';
import 'package:flutter/material.dart';


class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  static ThemeData getThemeByName(String themeName) {
    switch (themeName) {
      case 'Light':
        return MaterialTheme(TextTheme()).light();
      case 'Dark':
        return MaterialTheme(TextTheme()).dark();
      case 'Light High Contrast':
        return MaterialTheme(TextTheme()).lightHighContrast();
      case 'Dark High Contrast':
        return MaterialTheme(TextTheme()).darkHighContrast();
      default:
        return MaterialTheme(TextTheme()).light();
    }
  }
}
