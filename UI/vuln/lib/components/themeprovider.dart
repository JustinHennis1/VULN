import 'package:flutter/material.dart';
import 'package:vuln/components/themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = redTheme;

  ThemeData get currentTheme => _currentTheme;

  void setTheme(String theme) {
    if (theme == 'Dark') {
      _currentTheme = darkTheme;
    } else if (theme == 'Light') {
      _currentTheme = lightTheme;
    } else if (theme == 'Red') {
      _currentTheme = redTheme;
    } else if (theme == 'Blue') {
      _currentTheme = blueTheme;
    } else if (theme == 'Green') {
      _currentTheme = greenTheme;
    }

    notifyListeners();
  }
}
