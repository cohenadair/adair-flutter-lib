import 'package:adair_flutter_lib/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  testWidgets("No icon", (tester) async {
    var pressed = false;
    final button = Button(text: "Test", onPressed: () => pressed = true);

    await pumpContext(tester, (_) => button);

    expect(find.byWidget(button), findsOneWidget);
    await tester.tap(find.byWidget(button));
    expect(pressed, isTrue);
  });

  testWidgets("Icon", (tester) async {
    await pumpContext(
      tester,
      (_) => Button(
        text: "Test",
        onPressed: () => {},
        icon: const Icon(Icons.group),
      ),
    );
    expect(find.byIcon(Icons.group), findsOneWidget);
  });

  testWidgets("Material 3 shows exact text", (tester) async {
    await pumpContext(
      tester,
      (_) => Button(text: "Test Button", onPressed: () {}),
      useMaterial3: true,
    );
    expect(find.text("Test Button"), findsOneWidget);
    expect(find.text("TEST BUTTON"), findsNothing);
  });

  testWidgets("Material 2 shows uppercased text", (tester) async {
    await pumpContext(
      tester,
      (_) => Button(text: "Test Button", onPressed: () {}),
      useMaterial3: false,
    );
    expect(find.text("Test Button"), findsNothing);
    expect(find.text("TEST BUTTON"), findsOneWidget);
  });
}
