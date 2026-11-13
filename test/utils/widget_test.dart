import 'package:adair_flutter_lib/utils/widget.dart';
// Imported to verify legacy widgets resolve through the compatibility bridge.
// ignore: deprecated_member_use
import 'package:flutter/material.dart' as legacy;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../test_utils/testable.dart';

void main() {
  testWidgets("globalPosition returns null when key has no context", (
    tester,
  ) async {
    expect(GlobalKey().globalPosition(), isNull);
  });

  testWidgets("globalPosition returns rect matching size and offset", (
    tester,
  ) async {
    final key = GlobalKey();
    await pumpContext(
      tester,
      (_) => Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(key: key, height: 50.0, width: 75.0),
        ),
      ),
    );

    final position = key.globalPosition();
    expect(position, isNotNull);
    expect(position!.width, 75.0);
    expect(position.height, 50.0);
  });

  testWidgets(
    "materialUiCompatibilityBuilder exposes theme to legacy Material",
    (tester) async {
      late legacy.ThemeData legacyTheme;
      late legacy.MaterialLocalizations legacyLocalizations;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(primary: Colors.red),
          ),
          builder: materialUiCompatibilityBuilder,
          home: Builder(
            builder: (context) {
              legacyTheme = legacy.Theme.of(context);
              legacyLocalizations = legacy.MaterialLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(legacyTheme.colorScheme.primary, Colors.red);
      expect(legacyLocalizations.okButtonLabel, "OK");
    },
  );
}
