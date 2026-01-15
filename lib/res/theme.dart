import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_config.dart';

// TODO: There's not a ton of commonality here, and _elevatedButtonTheme
//  doesn't work for Material 3. Should revert to Flutter defaults wherever
//  possible (i.e. remove most of what's in this file in favour of proper
//  Flutter theming + extensions (if needed).

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

  static ElevatedButtonThemeData _elevatedButtonTheme() =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty<Color>.fromMap({
            WidgetState.any: AppConfig.get.colorAppTheme,
          }),
        ),
      );
}

@immutable
class AdairFlutterLibThemeExtension
    extends ThemeExtension<AdairFlutterLibThemeExtension> {
  /// The app's main theme color.
  final Color? app;

  /// The primary (full emphasis) color of widgets rendered on top of [app].
  final Color? onApp;

  /// The secondary (less emphasis) color of widgets rendered on top of [app].
  final Color? onAppSecondary;

  const AdairFlutterLibThemeExtension({
    this.app,
    this.onApp,
    this.onAppSecondary,
  });

  @override
  ThemeExtension<AdairFlutterLibThemeExtension> copyWith({
    Color? app,
    Color? onApp,
    Color? onAppSecondary,
  }) {
    return AdairFlutterLibThemeExtension(
      app: app ?? this.app,
      onApp: onApp ?? this.onApp,
      onAppSecondary: onAppSecondary ?? this.onAppSecondary,
    );
  }

  @override
  ThemeExtension<AdairFlutterLibThemeExtension> lerp(
    covariant ThemeExtension<AdairFlutterLibThemeExtension>? other,
    double t,
  ) {
    if (other is! AdairFlutterLibThemeExtension) {
      return this;
    }
    return AdairFlutterLibThemeExtension(
      app: Color.lerp(app, other.app, t),
      onApp: Color.lerp(onApp, other.onApp, t),
      onAppSecondary: Color.lerp(onAppSecondary, other.onAppSecondary, t),
    );
  }
}

extension BuildContexts on BuildContext {
  // TODO: Can be replaced with
  //  `bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;`
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

  TextStyle get styleError => TextStyle(color: colorError);

  TextStyle get styleOnApp => TextStyle(color: colorOnApp);

  TextStyle get styleOnAppSecondary => TextStyle(color: colorOnAppSecondary);

  Color get colorError => Theme.of(this).colorScheme.error;

  Color get colorApp =>
      Theme.of(this).extension<AdairFlutterLibThemeExtension>()?.app ??
      Colors.pink;

  Color get colorOnApp =>
      Theme.of(this).extension<AdairFlutterLibThemeExtension>()?.onApp ??
      Colors.white;

  Color get colorOnAppSecondary =>
      Theme.of(
        this,
      ).extension<AdairFlutterLibThemeExtension>()?.onAppSecondary ??
      Colors.white54;

  Color get colorText => isDarkTheme ? Colors.white : Colors.black;

  Color get colorBarChartLines => isDarkTheme ? Colors.white12 : Colors.black12;

  Color get colorBoxShadow => isDarkTheme ? Colors.black54 : Colors.grey;

  Color get colorSecondaryText => isDarkTheme ? Colors.white54 : Colors.black54;

  Color get colorGreyAccentLight =>
      isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade200;

  SystemUiOverlayStyle get appBarSystemStyle =>
      isDarkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
}
