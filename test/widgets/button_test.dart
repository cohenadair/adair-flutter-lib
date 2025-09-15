import 'package:adair_flutter_lib/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  group("Button", () {
    testWidgets("No icon", (tester) async {
      var pressed = false;
      var button = Button(text: "Test", onPressed: () => pressed = true);

      await tester.pumpWidget(Testable((_) => button));

      expect(find.byWidget(button), findsOneWidget);
      await tester.tap(find.byWidget(button));
      expect(pressed, isTrue);
    });

    testWidgets("Icon", (tester) async {
      var button = Button(
        text: "Test",
        onPressed: () => {},
        icon: const Icon(Icons.group),
      );

      await tester.pumpWidget(Testable((_) => button));
      expect(find.byIcon(Icons.group), findsOneWidget);
    });
  });
}
