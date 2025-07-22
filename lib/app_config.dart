import 'package:flutter/material.dart';

class AppConfig {
  static var _instance = AppConfig._();

  static AppConfig get get => _instance;

  @visibleForTesting
  static void set(AppConfig manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = AppConfig._();

  AppConfig._();

  late final String Function() appName;
  late final IconData appIcon;
  late final MaterialColor colorAppTheme;
  late final ThemeMode Function() themeMode;

  /// Needs to be called while initializing the main Flutter app, likely in
  /// initState.
  void init({
    required String Function() appName,
    IconData? appIcon,
    MaterialColor? colorAppTheme,
    ThemeMode Function()? themeMode,
  }) {
    this.appName = appName;
    this.appIcon = appIcon ?? Icons.not_interested;
    this.colorAppTheme = colorAppTheme ?? Colors.pink;
    this.themeMode = themeMode ?? () => ThemeMode.system;
  }
}
