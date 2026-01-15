import 'package:flutter/material.dart';

// TODO: Rename to AdairFlutterLibAppConfig to be consistent with other
//  lib-specific classes (or rename the other classes).
class AppConfig {
  static var _instance = AppConfig._();

  static AppConfig get get => _instance;

  @visibleForTesting
  static void set(AppConfig manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = AppConfig._();

  AppConfig._();

  // TODO: Don't need to be functions; names shouldn't be internationalized and
  //  therefore, should not need Root.buildContext.
  late final String Function() appName;
  late final String Function()? companyName;
  late final IconData appIcon;

  // TODO: All theme-related properties should be handled in the app's theme.
  //  Remove them from here.
  @Deprecated(
    "Use BuildContext.colorApp instead, and set theme colors using AdairFlutterLibThemeExtension.",
  )
  late final MaterialColor colorAppTheme;

  // TODO: Equivalent to onApp. Should be deprecated.
  late final Color Function(bool) colorAppBarContent;
  late final ThemeMode Function() themeMode;

  /// Needs to be called while initializing the main Flutter app, likely in
  /// initState.
  void init({
    required String Function() appName,
    String Function()? companyName,
    IconData? appIcon,
    MaterialColor? colorAppTheme,
    Color Function(bool)? colorAppBarContent,
    ThemeMode Function()? themeMode,
  }) {
    this.appName = appName;
    this.companyName = companyName;
    this.appIcon = appIcon ?? Icons.not_interested;
    this.colorAppTheme = colorAppTheme ?? Colors.pink;
    this.colorAppBarContent = colorAppBarContent ?? (_) => Colors.white;
    this.themeMode = themeMode ?? () => ThemeMode.system;
  }
}
