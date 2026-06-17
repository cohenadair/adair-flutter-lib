import 'package:adair_flutter_lib/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';

void main() {
  setUp(() async {
    await StubbedManagers.create();
  });

  test(
    "errorSnackBar returns a SnackBar with colorScheme.error as backgroundColor",
    () {
      final themeData = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      );
      final snackBar = errorSnackBar("Error message", themeData);
      expect(snackBar.backgroundColor, themeData.colorScheme.error);
    },
  );

  test("errorSnackBar uses snackBarDurationDefault for its duration", () {
    final themeData = ThemeData();
    final snackBar = errorSnackBar("Error message", themeData);
    expect(snackBar.duration, const Duration(seconds: snackBarDurationDefault));
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
