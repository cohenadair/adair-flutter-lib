import 'package:adair_flutter_lib/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  testWidgets("showErrorSnackBar shows a SnackBar with the error message", (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () => showErrorSnackBar(context, "Something failed"),
                child: const Text("trigger"),
              ),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text("trigger"));
    await tester.pump();
    expect(find.text("Something failed"), findsOneWidget);
  });
}
