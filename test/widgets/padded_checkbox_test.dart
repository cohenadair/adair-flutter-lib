import 'package:adair_flutter_lib/widgets/padded_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/finder.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';
import '../test_utils/widget.dart';

void main() {
  setUp(() async {
    await StubbedManagers.create();
  });

  testWidgets("Renders unchecked when checked is false", (tester) async {
    await pumpContext(tester, (_) => const PaddedCheckbox(isChecked: false));

    expect(findFirst<Checkbox>(tester).value, isFalse);
  });

  testWidgets("Renders checked when checked is true", (tester) async {
    await pumpContext(tester, (_) => const PaddedCheckbox(isChecked: true));

    expect(findFirst<Checkbox>(tester).value, isTrue);
  });

  testWidgets("Tapping unchecked fires onChanged with true", (tester) async {
    bool? received;
    await pumpContext(
      tester,
      (_) => PaddedCheckbox(onChanged: (value) => received = value),
    );

    await tapAndSettle(tester, find.byType(Checkbox));

    expect(received, isTrue);
  });

  testWidgets("Tapping checked fires onChanged with false", (tester) async {
    bool? received;
    await pumpContext(
      tester,
      (_) => PaddedCheckbox(
        isChecked: true,
        onChanged: (value) => received = value,
      ),
    );

    await tapAndSettle(tester, find.byType(Checkbox));

    expect(received, isFalse);
  });

  testWidgets("isEnabled false sets Checkbox onChanged to null", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (_) => PaddedCheckbox(isEnabled: false, onChanged: (_) {}),
    );

    expect(findFirst<Checkbox>(tester).onChanged, isNull);
  });

  testWidgets("onChanged null does not throw when tapped", (tester) async {
    await pumpContext(tester, (_) => const PaddedCheckbox(onChanged: null));

    await tapAndSettle(tester, find.byType(Checkbox));
  });

  testWidgets("didUpdateWidget syncs isChecked when parent value changes", (
    tester,
  ) async {
    var checked = false;
    await pumpContext(
      tester,
      (_) => StatefulBuilder(
        builder: (_, setState) => Column(
          children: [
            PaddedCheckbox(isChecked: checked),
            ElevatedButton(
              onPressed: () => setState(() => checked = true),
              child: const Text("update"),
            ),
          ],
        ),
      ),
    );

    expect(findFirst<Checkbox>(tester).value, isFalse);

    await tapAndSettle(tester, find.text("update"));

    expect(findFirst<Checkbox>(tester).value, isTrue);
  });

  testWidgets("didUpdateWidget keeps state when parent value is unchanged", (
    tester,
  ) async {
    var checked = false;
    await pumpContext(
      tester,
      (_) => StatefulBuilder(
        builder: (_, setState) => Column(
          children: [
            PaddedCheckbox(isChecked: checked),
            ElevatedButton(
              onPressed: () => setState(() {}),
              child: const Text("rebuild"),
            ),
          ],
        ),
      ),
    );

    expect(findFirst<Checkbox>(tester).value, isFalse);

    await tapAndSettle(tester, find.text("rebuild"));

    expect(findFirst<Checkbox>(tester).value, isFalse);
  });

  testWidgets("Custom padding is applied", (tester) async {
    const padding = EdgeInsets.all(8);
    await pumpContext(tester, (_) => const PaddedCheckbox(padding: padding));

    expect(findFirst<Padding>(tester).padding, padding);
  });
}
