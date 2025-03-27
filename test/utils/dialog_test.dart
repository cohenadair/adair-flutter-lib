import 'package:adair_flutter_lib/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/finder.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/widget.dart';

void main() {
  late StubbedManagers managers;

  setUp(() {
    managers = StubbedManagers();
    when(managers.ioWrapper.isAndroid).thenReturn(false);
  });

  testWidgets("DialogButton popsOnTap=true", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) =>
            const DialogButton(label: "Test", isEnabled: true, popOnTap: true),
      ),
    );

    await tapAndSettle(tester, find.text("TEST"));
    expect(find.byType(DialogButton), findsNothing);
  });

  testWidgets("DialogButton popsOnTap=false", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) =>
            const DialogButton(label: "Test", isEnabled: true, popOnTap: false),
      ),
    );

    await tapAndSettle(tester, find.text("TEST"));
    expect(find.byType(DialogButton), findsOneWidget);
  });

  testWidgets("DialogButton disabled", (tester) async {
    await tester.pumpWidget(
      Testable((_) => const DialogButton(label: "Test", isEnabled: false)),
    );

    var button = findFirstWithText<TextButton>(tester, "TEST");
    expect(button.onPressed, isNull);
  });
}
