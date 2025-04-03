import 'package:adair_flutter_lib/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/finder.dart';
import '../test_utils/testable.dart';

void main() {
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
    await tester.pumpWidget(Testable((_) => const Loading.appBar()));
    expect(findFirst<CircularProgressIndicator>(tester).color, isNotNull);
  });

  testWidgets("Default has null color", (tester) async {
    await tester.pumpWidget(Testable((_) => const Loading(isAppBar: false)));
    expect(findFirst<CircularProgressIndicator>(tester).color, isNull);
  });
}
