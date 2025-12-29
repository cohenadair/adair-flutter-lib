import 'package:adair_flutter_lib/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/finder.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
  });

  testWidgets("Centered includes a centered column", (tester) async {
    await tester.pumpWidget(
      Testable((_) => const Loading(isCentered: true, label: "Test...")),
    );

    expect(find.byType(Column), findsOneWidget);
    expect(
      findFirst<Column>(tester).mainAxisAlignment,
      MainAxisAlignment.center,
    );
  });

  testWidgets("Label not centered includes start aligned column", (
    tester,
  ) async {
    await tester.pumpWidget(
      Testable((_) => const Loading(isCentered: false, label: "Test...")),
    );

    expect(find.byType(Column), findsOneWidget);
    expect(
      findFirst<Column>(tester).mainAxisAlignment,
      MainAxisAlignment.start,
    );
  });

  testWidgets("Not centered; no label just shows indicator", (tester) async {
    await tester.pumpWidget(Testable((_) => const Loading(isCentered: false)));
    expect(find.byType(Column), findsNothing);
  });

  testWidgets("App bar uses custom color", (tester) async {
    when(managers.appConfig.colorAppBarContent).thenReturn((_) => Colors.pink);
    await tester.pumpWidget(Testable((_) => const Loading.appBar()));
    expect(
      findFirst<CircularProgressIndicator>(tester).color,
      equals(Colors.pink),
    );
  });

  testWidgets("Default has null color", (tester) async {
    await tester.pumpWidget(Testable((_) => const Loading(isAppBar: false)));
    expect(findFirst<CircularProgressIndicator>(tester).color, isNull);
  });
}
