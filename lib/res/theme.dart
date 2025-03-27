import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const themeMode = ThemeMode.system;

extension BuildContexts on BuildContext {
  bool get isDarkTheme {
    switch (themeMode) {
      case ThemeMode.system:
        return MediaQuery.of(this).platformBrightness == Brightness.dark;
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
    }
  }

  Color get colorText => isDarkTheme ? Colors.white : Colors.black;

  Color get colorTextActionBar => Colors.white;

  Color get colorBarChartLines => isDarkTheme ? Colors.white12 : Colors.black12;

  Color get colorBoxShadow => isDarkTheme ? Colors.black54 : Colors.grey;

  Color get colorSecondaryText => isDarkTheme ? Colors.white54 : Colors.black54;

  SystemUiOverlayStyle get appBarSystemStyle =>
      isDarkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
}
