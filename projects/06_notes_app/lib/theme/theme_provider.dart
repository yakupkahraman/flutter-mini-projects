import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkTheme;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightTheme) {
      themeData = darkTheme;
    } else {
      themeData = lightTheme;
    }
    _saveTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    themeData = isDarkMode ? darkTheme : lightTheme;
  }

  void _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _themeData == darkTheme);
  }
}
