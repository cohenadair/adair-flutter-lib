import 'package:adair_flutter_lib/utils/string.dart';
import 'package:flutter/material.dart';

class AppConfig {
  static var _instance = AppConfig._();

  static AppConfig get get => _instance;

  @visibleForTesting
  static void set(AppConfig manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = AppConfig._();

  AppConfig._();

  late final StringCallback appName;
  late final IconData appIcon;
  late final Color colorAppTheme;

  void init({
    required StringCallback appName,
    IconData? appIcon,
    Color? colorAppTheme,
  }) {
    this.appName = appName;
    this.appIcon = appIcon ?? Icons.not_interested;
    this.colorAppTheme = colorAppTheme ?? Colors.pink;
  }
}
