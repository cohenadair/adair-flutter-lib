import 'package:adair_flutter_lib/widgets/chip_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/finder.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';

void main() {
  setUp(() async {
    await StubbedManagers.create();
  });

  testWidgets("Enabled", (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      Testable(
        (_) => ChipButton(label: "Test", onPressed: () => pressed = true),
      ),
    );
    await tester.tap(find.byType(ChipButton));
    expect(pressed, isTrue);
  });

  testWidgets("Without icon", (tester) async {
    await tester.pumpWidget(
      Testable((_) => ChipButton(label: "Test", onPressed: () => {})),
    );
    var chip = findFirst<ActionChip>(tester);
    expect(chip.avatar, isNull);
  });

  testWidgets("With icon", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) => ChipButton(label: "Test", icon: Icons.add, onPressed: () => {}),
      ),
    );
    var chip = findFirst<ActionChip>(tester);
    expect(chip.avatar, isNotNull);
  });
}
