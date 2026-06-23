import 'package:adair_flutter_lib/widgets/checkbox_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/finder.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';
import '../test_utils/widget.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();

    when(
      managers.subscriptionManager.subscriptions(),
    ).thenAnswer((_) => Future.value(null));
  });

  testWidgets("Enabled", (tester) async {
    var checked = false;
    await tester.pumpWidget(
      Testable(
        (_) => CheckboxInput(label: "Test", onChanged: (_) => checked = true),
      ),
    );
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(checked, isTrue);
    expect(findFirst<Checkbox>(tester).value, isTrue);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(findFirst<Checkbox>(tester).value, isFalse);
  });

  testWidgets("Disabled", (tester) async {
    await tester.pumpWidget(
      Testable((_) => CheckboxInput(label: "Test", enabled: false)),
    );
    expect(findFirst<Checkbox>(tester).onChanged, isNull);
  });

  testWidgets("Hides description", (tester) async {
    await pumpContext(tester, (_) => CheckboxInput(label: "Test"));
    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets("Shows description", (tester) async {
    await pumpContext(
      tester,
      (_) => CheckboxInput(label: "Test", description: "Description"),
    );
    expect(find.text("Description"), findsOneWidget);
  });

  testWidgets("Shows help button when helpText is provided", (tester) async {
    await pumpContext(
      tester,
      (_) => CheckboxInput(label: "Test", helpText: "Help content"),
    );
    expect(find.byIcon(Icons.help_outline), findsOneWidget);
  });

  testWidgets("Hides help button when helpText is not provided", (
    tester,
  ) async {
    await pumpContext(tester, (_) => CheckboxInput(label: "Test"));
    expect(find.byIcon(Icons.help_outline), findsNothing);
  });

  testWidgets("Help button shows dialog with helpText", (tester) async {
    await pumpContext(
      tester,
      (_) => CheckboxInput(label: "Test", helpText: "Help content"),
    );
    await tapAndSettle(tester, find.byIcon(Icons.help_outline));
    expect(find.text("Help content"), findsOneWidget);
  });

  testWidgets("ProCheckboxInput gets checked on tap if pro", (tester) async {
    when(managers.subscriptionManager.isPro).thenReturn(true);

    await pumpContext(
      tester,
      (_) => ProCheckboxInput(
        label: "Test",
        value: false,
        onProRequired: () {},
        onSetValue: (_) {},
      ),
    );

    await tapAndSettle(tester, find.byType(Checkbox));
    expect(findFirst<Checkbox>(tester).value!, isTrue);
  });

  testWidgets("ProCheckboxInput calls onProRequired on tap if not pro", (
    tester,
  ) async {
    when(managers.subscriptionManager.isPro).thenReturn(false);
    var proRequiredCalled = false;

    await pumpContext(
      tester,
      (_) => ProCheckboxInput(
        label: "Test",
        value: false,
        onProRequired: () => proRequiredCalled = true,
        onSetValue: (_) {},
      ),
    );

    await tapAndSettle(tester, find.byType(Checkbox));
    expect(proRequiredCalled, isTrue);
    expect(findFirst<Checkbox>(tester).value!, isFalse);
  });

  testWidgets("ProCheckboxInput syncs when parent value changes", (
    tester,
  ) async {
    when(managers.subscriptionManager.isPro).thenReturn(true);
    var value = false;

    await pumpContext(
      tester,
      (_) => StatefulBuilder(
        builder: (_, setState) => Column(
          children: [
            ProCheckboxInput(
              label: "Test",
              value: value,
              onProRequired: () {},
              onSetValue: (_) {},
            ),
            ElevatedButton(
              onPressed: () => setState(() => value = true),
              child: const Text("update"),
            ),
          ],
        ),
      ),
    );

    expect(findFirst<Checkbox>(tester).value!, isFalse);

    await tapAndSettle(tester, find.text("update"));

    expect(findFirst<Checkbox>(tester).value!, isTrue);
  });

  testWidgets("ProCheckboxInput gets unchecked", (tester) async {
    when(managers.subscriptionManager.isPro).thenReturn(true);

    await pumpContext(
      tester,
      (_) => ProCheckboxInput(
        label: "Test",
        value: true,
        onProRequired: () {},
        onSetValue: (_) {},
      ),
    );

    expect(findFirst<Checkbox>(tester).value!, isTrue);

    await tapAndSettle(tester, find.byType(Checkbox));
    expect(findFirst<Checkbox>(tester).value!, isFalse);
  });
}
