import 'package:adair_flutter_lib/l10n/gen/adair_flutter_lib_localizations.dart';
import 'package:adair_flutter_lib/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// A widget that wraps a child in default localizations.
class Testable extends StatelessWidget {
  final WidgetBuilder builder;
  final MediaQueryData mediaQueryData;
  final TargetPlatform? platform;
  final ThemeMode? themeMode;
  final List<LocalizationsDelegate> localizations;

  const Testable(
    this.builder, {
    this.mediaQueryData = const MediaQueryData(),
    this.platform,
    this.themeMode,
    this.localizations = const [],
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.lightBlue,
        platform: platform,
      ),
      localizationsDelegates: [
        AdairFlutterLibLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ...localizations,
      ],
      locale: const Locale("en", "CA"),
      home: MediaQuery(
        data: mediaQueryData,
        child: Material(child: Builder(builder: builder)),
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
  BuildContext? context;
  await tester.pumpWidget(
    Testable(
      (buildContext) {
        context = buildContext;
        return const Empty();
      },
      mediaQueryData: MediaQueryData(
        devicePixelRatio: 1.0,
        alwaysUse24HourFormat: use24Hour,
      ),
      localizations: localizations,
    ),
  );
  return context!;
}
