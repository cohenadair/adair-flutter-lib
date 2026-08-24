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

  // Per-context logo asset paths (SVGs), rendered via TintedSvgPicture. Null
  // when an app has no use for that context (e.g. pro-iq has no pro page).
  // Exposed as asserting getters below rather than directly, so a call site
  // that reaches a context the app never configured fails fast with a clear
  // message instead of a bare null-check-operator crash.
  late final String? _signInLogo;
  late final String? _landingLogo;
  late final String? _proLogo;

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
    String? signInLogo,
    String? landingLogo,
    String? proLogo,
    MaterialColor? colorAppTheme,
    Color Function(bool)? colorAppBarContent,
    ThemeMode Function()? themeMode,
  }) {
    this.appName = appName;
    this.companyName = companyName;
    _signInLogo = signInLogo;
    _landingLogo = landingLogo;
    _proLogo = proLogo;
    this.colorAppTheme = colorAppTheme ?? Colors.pink;
    this.colorAppBarContent = colorAppBarContent ?? (_) => Colors.white;
    this.themeMode = themeMode ?? () => ThemeMode.system;
  }

  String get signInLogo {
    assert(_signInLogo != null, "signInLogo was not provided to init()");
    return _signInLogo!;
  }

  String get landingLogo {
    assert(_landingLogo != null, "landingLogo was not provided to init()");
    return _landingLogo!;
  }

  String get proLogo {
    assert(_proLogo != null, "proLogo was not provided to init()");
    return _proLogo!;
  }
}
