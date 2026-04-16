import 'package:adair_flutter_lib/widgets/dropdown_options_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';
import '../test_utils/widget.dart';

void main() {
  testWidgets("DropdownOptionsView renders all children", (tester) async {
    await pumpContext(
      tester,
      (_) => DropdownOptionsView(
        children: [const Text("First"), const Text("Second")],
      ),
    );

    expect(find.text("First"), findsOneWidget);
    expect(find.text("Second"), findsOneWidget);
  });

  testWidgets("DropdownOptionItem renders its child", (tester) async {
    await pumpContext(
      tester,
      (_) => DropdownOptionItem(onTap: () {}, child: const Text("Option")),
    );

    expect(find.text("Option"), findsOneWidget);
  });

  testWidgets("DropdownOptionItem calls onTap when tapped", (tester) async {
    var tapped = false;

    await pumpContext(
      tester,
      (_) => DropdownOptionItem(
        onTap: () => tapped = true,
        child: const Text("Option"),
      ),
    );

    await tapAndSettle(tester, find.text("Option"));

    expect(tapped, isTrue);
  });

  testWidgets("DropdownAnchor renders the trigger and no children initially", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (_) => DropdownAnchor(
        triggerBuilder: (_, _) => const Text("Open"),
        childrenBuilder: (_) => [const Text("Item")],
      ),
    );

    expect(find.text("Open"), findsOneWidget);
    expect(find.text("Item"), findsNothing);
  });

  testWidgets(
    "DropdownAnchor shows children in overlay when trigger is tapped (alignRight false)",
    (tester) async {
      await pumpContext(
        tester,
        (_) => DropdownAnchor(
          triggerBuilder: (_, open) =>
              TextButton(onPressed: open, child: const Text("Open")),
          childrenBuilder: (_) => [const Text("Item")],
        ),
      );

      await tapAndSettle(tester, find.text("Open"));

      expect(find.text("Item"), findsOneWidget);
    },
  );

  testWidgets(
    "DropdownAnchor shows children in overlay when trigger is tapped (alignRight true)",
    (tester) async {
      await pumpContext(
        tester,
        (_) => DropdownAnchor(
          alignRight: true,
          triggerBuilder: (_, open) =>
              TextButton(onPressed: open, child: const Text("Open")),
          childrenBuilder: (_) => [const Text("Item")],
        ),
      );

      await tapAndSettle(tester, find.text("Open"));

      expect(find.text("Item"), findsOneWidget);
    },
  );

  testWidgets("Close callback provided to childrenBuilder hides the overlay", (
    tester,
  ) async {
    // Align the trigger at the top so the overlay renders within the viewport.
    await pumpContext(
      tester,
      (_) => Align(
        alignment: Alignment.topLeft,
        child: DropdownAnchor(
          triggerBuilder: (_, open) =>
              TextButton(onPressed: open, child: const Text("Open")),
          childrenBuilder: (close) => [
            TextButton(onPressed: close, child: const Text("Close")),
          ],
        ),
      ),
    );

    await tapAndSettle(tester, find.text("Open"));
    expect(find.text("Close"), findsOneWidget);

    await tapAndSettle(tester, find.text("Close"));
    expect(find.text("Close"), findsNothing);
  });
}
