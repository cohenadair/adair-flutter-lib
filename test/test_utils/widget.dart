import 'package:adair_flutter_lib/l10n/gen/adair_flutter_lib_localizations.dart';
import 'package:adair_flutter_lib/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// A widget that wraps a child in default localizations.
class Testable extends StatelessWidget {
  final Widget Function(BuildContext) builder;
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
    ),
  );
  return context!;
}

void setCanvasSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
}

Future<void> ensureVisibleAndSettle(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

Future<void> tapAndSettle(
  WidgetTester tester,
  Finder finder, [
  int? durationMillis,
]) async {
  await tester.tap(finder);
  if (durationMillis == null) {
    await tester.pumpAndSettle();
  } else {
    await tester.pumpAndSettle(Duration(milliseconds: durationMillis));
  }
}

Future<void> enterTextAndSettle(
  WidgetTester tester,
  Finder finder,
  String text,
) async {
  await tester.enterText(finder, text);
  await tester.pumpAndSettle();
}

Future<void> enterTextFieldAndSettle(
  WidgetTester tester,
  String textFieldTitle,
  String text,
) async {
  await tester.enterText(find.widgetWithText(TextField, textFieldTitle), text);
  await tester.pumpAndSettle();
}
