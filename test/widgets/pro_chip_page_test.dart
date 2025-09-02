import 'package:adair_flutter_lib/widgets/chip_button.dart';
import 'package:adair_flutter_lib/widgets/pro_chip_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();

    when(
      managers.subscriptionManager.stream,
    ).thenAnswer((_) => const Stream.empty());
  });

  testWidgets("Empty widget if user is pro", (tester) async {
    when(managers.subscriptionManager.isPro).thenReturn(true);
    await pumpContext(tester, (_) => ProChipButton(SizedBox()));

    expect(find.byType(SizedBox), findsOneWidget);
    expect(find.byType(ChipButton), findsNothing);
  });

  testWidgets("Button shows if user is free", (tester) async {
    when(managers.subscriptionManager.isPro).thenReturn(false);
    await pumpContext(tester, (_) => ProChipButton(SizedBox()));

    expect(find.byType(ChipButton), findsOneWidget);
  });
}
