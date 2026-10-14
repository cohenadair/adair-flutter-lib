import 'package:adair_flutter_lib/widgets/loading.dart';
import 'package:adair_flutter_lib/widgets/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';
import '../test_utils/widget.dart';

void main() {
  setUp(() async {
    await StubbedManagers.create();
  });

  Future<void> pumpButton(
    WidgetTester tester, {
    required bool isLoading,
    VoidCallback? onPressed,
  }) => pumpContext(
    tester,
    (_) => Center(
      child: LoadingButton(
        text: "Save",
        isLoading: isLoading,
        onPressed: onPressed ?? () {},
      ),
    ),
  );

  testWidgets("Tapping while idle invokes onPressed", (tester) async {
    var pressed = false;
    await pumpButton(tester, isLoading: false, onPressed: () => pressed = true);

    await tapAndSettle(tester, find.byType(ElevatedButton));

    expect(pressed, isTrue);
  });

  testWidgets("Tapping while loading does not invoke onPressed", (
    tester,
  ) async {
    var pressed = false;
    await pumpButton(tester, isLoading: true, onPressed: () => pressed = true);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(pressed, isFalse);
  });

  testWidgets("Text is shown and loading hidden while idle", (tester) async {
    await pumpButton(tester, isLoading: false);

    expect(find.text("Save").hitTestable(), findsOneWidget);
    expect(tester.widget<Loading>(find.byType(Loading)).isShowing, isFalse);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets("Text is hidden and loading shown while loading", (tester) async {
    await pumpButton(tester, isLoading: true);

    expect(find.text("Save").hitTestable(), findsNothing);
    expect(tester.widget<Loading>(find.byType(Loading)).isShowing, isTrue);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Button is the same size while idle and loading", (tester) async {
    await pumpButton(tester, isLoading: false);
    final idleSize = tester.getSize(find.byType(ElevatedButton));

    await pumpButton(tester, isLoading: true);

    expect(tester.getSize(find.byType(ElevatedButton)), idleSize);
  });
}
