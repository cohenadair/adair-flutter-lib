import 'package:adair_flutter_lib/l10n/gen/adair_flutter_lib_localizations.dart';
import 'package:adair_flutter_lib/utils/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// A widget that wraps a child in default localizations.
class Testable extends StatelessWidget {
  /// A convenient way to use [Testable] in non-library project tests, without
  /// having to create a wrapped [Testable] widget.
  static List<LocalizationsDelegate> additionalLocalizations = [];
  static List<Locale> additionalLocales = [];

  final WidgetBuilder builder;
  final MediaQueryData mediaQueryData;
  final TargetPlatform? platform;
  final ThemeMode? themeMode;
  final Iterable<LocalizationsDelegate> localizations;
  final Iterable<Locale>? locales;
  final Locale? locale;
  final bool useMaterial3;

  const Testable(
    this.builder, {
    this.mediaQueryData = const MediaQueryData(),
    this.platform,
    this.themeMode,
    this.localizations = const [],
    this.locales,
    this.locale,
    this.useMaterial3 = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: useMaterial3,
        primarySwatch: Colors.lightBlue,
        platform: platform,
      ),
      localizationsDelegates: [
        AdairFlutterLibLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ...localizations,
        ...additionalLocalizations,
      ],
      supportedLocales: [
        ...AdairFlutterLibLocalizations.supportedLocales,
        ...locales ?? [],
        ...additionalLocales,
      ],
      locale: locale ?? const Locale("en", "CA"),
      home: MediaQuery(
        data: mediaQueryData,
        child: Material(
          child: Builder(
            builder: (context) {
              Root.get.buildContext = context;
              return builder(context);
            },
          ),
        ),
      ),
    );
  }
}

/// A convenience method for creating a [BuildContext] instance in a non-UI
/// test.
Future<BuildContext> buildContext(
  WidgetTester tester, {
  bool use24Hour = false,
  List<LocalizationsDelegate> localizations = const [],
}) async {
  return pumpContext(
    tester,
    (_) => const SizedBox(),
    mediaQueryData: MediaQueryData(
      devicePixelRatio: 1.0,
      alwaysUse24HourFormat: use24Hour,
    ),
    localizations: localizations,
  );
}

Future<BuildContext> pumpContext(
  WidgetTester tester,
  Widget Function(BuildContext) builder, {
  MediaQueryData mediaQueryData = const MediaQueryData(),
  ThemeMode? themeMode,
  Locale? locale,
  bool useMaterial3 = false,
  List<LocalizationsDelegate> localizations = const [],
}) async {
  late BuildContext context;
  await tester.pumpWidget(
    Testable(
      (buildContext) {
        context = buildContext;
        return builder(context);
      },
      mediaQueryData: mediaQueryData,
      themeMode: themeMode,
      locale: locale,
      useMaterial3: useMaterial3,
      localizations: localizations,
    ),
  );
  return context;
}
