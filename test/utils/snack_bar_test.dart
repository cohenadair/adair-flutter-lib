import 'package:adair_flutter_lib/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';

void main() {
  setUp(() async {
    await StubbedManagers.create();
  });

  test("errorSnackBar uses an opaque errorContainer as its background", () {
    final themeData = ThemeData(
      colorScheme: ColorScheme.dark(errorContainer: Colors.pink.shade500),
    );
    expect(
      errorSnackBar("Error message", themeData).backgroundColor,
      Colors.pink.shade500,
    );
  });

  test("errorSnackBar blends a translucent errorContainer onto scaffold", () {
    final errorContainer = Colors.pink.withAlpha(150);
    final themeData = ThemeData(
      colorScheme: ColorScheme.dark(errorContainer: errorContainer),
      scaffoldBackgroundColor: Colors.black,
    );
    expect(
      errorSnackBar("Error message", themeData).backgroundColor,
      Color.alphaBlend(errorContainer, Colors.black),
    );
  });

  test("errorSnackBar uses snackBarDurationDefault for its duration", () {
    final themeData = ThemeData();
    final snackBar = errorSnackBar("Error message", themeData);
    expect(snackBar.duration, const Duration(seconds: snackBarDurationDefault));
  });

  test("errorSnackBar uses colorScheme.onErrorContainer for its text", () {
    final themeData = ThemeData(
      colorScheme: const ColorScheme.dark(onErrorContainer: Colors.black),
    );
    final snackBar = errorSnackBar("Error message", themeData);
    expect((snackBar.content as Text).style?.color, Colors.black);
  });

  testWidgets("showSuccessSnackBar shows a SnackBar with the message", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (context) => Scaffold(
        body: TextButton(
          onPressed: () => showSuccessSnackBar(context, "All good"),
          child: const Text("trigger"),
        ),
      ),
    );
    await tester.tap(find.text("trigger"));
    await tester.pump();
    expect(find.text("All good"), findsOneWidget);
  });

  testWidgets("showErrorSnackBar shows a SnackBar with the error message", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (context) => Scaffold(
        body: TextButton(
          onPressed: () => showErrorSnackBar(context, "Something failed"),
          child: const Text("trigger"),
        ),
      ),
    );
    await tester.tap(find.text("trigger"));
    await tester.pump();
    expect(find.text("Something failed"), findsOneWidget);
  });
}
