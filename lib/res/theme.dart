import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_config.dart';

const useMaterial3 = false;

class AdairFlutterLibTheme {
  static ThemeData light() =>
      ThemeData.light(useMaterial3: useMaterial3).copyWith(
        primaryColor: AppConfig.get.colorAppTheme,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: AppConfig.get.colorAppTheme,
        ).copyWith(error: Colors.red),
        elevatedButtonTheme: _elevatedButtonTheme(),
      );

  static ThemeData dark() =>
      ThemeData.dark(useMaterial3: useMaterial3).copyWith(
        primaryColor: AppConfig.get.colorAppTheme,
        elevatedButtonTheme: _elevatedButtonTheme(),
      );

  static _elevatedButtonTheme() => ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty<Color>.fromMap({
        WidgetState.any: AppConfig.get.colorAppTheme,
      }),
    ),
  );
}

extension BuildContexts on BuildContext {
  bool get isDarkTheme {
    switch (AppConfig.get.themeMode()) {
      case ThemeMode.system:
        return MediaQuery.of(this).platformBrightness == Brightness.dark;
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
    }
  }

  // TODO: See if any of these can be moved to ThemeData.

  Color get colorText => isDarkTheme ? Colors.white : Colors.black;

  Color get colorTextActionBar => Colors.white;

  Color get colorBarChartLines => isDarkTheme ? Colors.white12 : Colors.black12;

  Color get colorBoxShadow => isDarkTheme ? Colors.black54 : Colors.grey;

  Color get colorSecondaryText => isDarkTheme ? Colors.white54 : Colors.black54;

  Color get colorGreyAccentLight =>
      isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade200;

  SystemUiOverlayStyle get appBarSystemStyle =>
      isDarkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
}
