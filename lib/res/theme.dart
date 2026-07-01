import 'package:adair_flutter_lib/res/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_config.dart';

// TODO: There's not a ton of commonality here, and _elevatedButtonTheme
//  doesn't work for Material 3. Should revert to Flutter defaults wherever
//  possible (i.e. remove most of what's in this file in favour of proper
//  Flutter theming + extensions (if needed).

// TODO: All color variables should fetch from a custom theme
//  (see BuildContexts.colorApp).

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

/// Should be used for an app's theme colors, not default styles or dimensions.
/// The latter should be declared in the [BuildContexts] extension.
@immutable
class AdairFlutterLibThemeExtension
    extends ThemeExtension<AdairFlutterLibThemeExtension> {
  /// The app's main theme color.
  final Color? app;

  /// The primary (full emphasis) color of widgets rendered on top of [app].
  final Color? onApp;

  /// The secondary (less emphasis) color of widgets rendered on top of [app].
  final Color? onAppSecondary;

  /// The disabled color of widgets rendered on top of [app].
  final Color? onAppDisabled;

  /// The app's success color (e.g. success snack bars).
  final Color? success;

  /// The primary color of widgets rendered on top of [success].
  final Color? onSuccess;

  // TODO: Move to BuildContext extension below.
  /// The radius of the top-left of a NavigationRail content widget, as shown
  /// in https://m3.material.io/components/navigation-rail/overview.
  final double navigationRailContentRadius;

  const AdairFlutterLibThemeExtension({
    this.app,
    this.onApp,
    this.onAppSecondary,
    this.onAppDisabled,
    this.success,
    this.onSuccess,
    this.navigationRailContentRadius = 36.0,
  });

  @override
  ThemeExtension<AdairFlutterLibThemeExtension> copyWith({
    Color? app,
    Color? onApp,
    Color? onAppSecondary,
    Color? onAppDisabled,
    Color? success,
    Color? onSuccess,
  }) {
    return AdairFlutterLibThemeExtension(
      app: app ?? this.app,
      onApp: onApp ?? this.onApp,
      onAppSecondary: onAppSecondary ?? this.onAppSecondary,
      onAppDisabled: onAppDisabled ?? this.onAppDisabled,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
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
      onAppDisabled: Color.lerp(onAppDisabled, other.onAppDisabled, t),
      success: Color.lerp(success, other.success, t),
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t),
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

  TextStyle get styleError =>
      TextStyle(color: colorError, fontSize: stylePrimary(this).fontSize);

  TextStyle get styleOnApp =>
      TextStyle(color: colorOnApp, fontSize: stylePrimary(this).fontSize);

  TextStyle get styleOnAppSecondary => TextStyle(
    color: colorOnAppSecondary,
    fontSize: stylePrimary(this).fontSize,
  );

  TextStyle? get styleTitleLargeBold => Theme.of(
    this,
  ).textTheme.titleLarge?.copyWith(fontWeight: fontWeightBoldTitle);

  TextStyle? get styleLabelMediumSecondary =>
      Theme.of(this).textTheme.labelMedium?.copyWith(color: colorSecondaryText);

  Color get colorError => Theme.of(this).colorScheme.error;

  Color get colorSuccess =>
      Theme.of(this).extension<AdairFlutterLibThemeExtension>()?.success ??
      Colors.green;

  Color get colorOnSuccess =>
      Theme.of(this).extension<AdairFlutterLibThemeExtension>()?.onSuccess ??
      Colors.white;

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

  Color get colorOnAppDisabled =>
      Theme.of(
        this,
      ).extension<AdairFlutterLibThemeExtension>()?.onAppDisabled ??
      Colors.white38;

  Color get colorText => isDarkTheme ? Colors.white : Colors.black;

  Color get colorBarChartLines => isDarkTheme ? Colors.white12 : Colors.black12;

  Color get colorBoxShadow => isDarkTheme ? Colors.black54 : Colors.grey;

  Color get colorSecondaryText => isDarkTheme ? Colors.white54 : Colors.black54;

  Color get colorGreyAccentLight =>
      isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade200;

  double get radiusNavigationRailContent =>
      Theme.of(this)
          .extension<AdairFlutterLibThemeExtension>()
          ?.navigationRailContentRadius ??
      0;

  TextStyle? get styleAppBarTitle =>
      (Theme.of(this).appBarTheme.titleTextStyle ??
              Theme.of(this).textTheme.titleLarge)
          ?.copyWith(color: colorOnAppBar);

  Color get colorOnAppBar =>
      isDarkTheme ? Theme.of(this).colorScheme.onSurface : colorOnApp;

  Color get colorOnAppBarDisabled =>
      isDarkTheme ? Colors.white38 : colorOnAppDisabled;

  SystemUiOverlayStyle get appBarSystemStyle =>
      isDarkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
}
