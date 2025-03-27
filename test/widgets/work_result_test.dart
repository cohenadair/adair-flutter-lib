import 'package:adair_flutter_lib/widgets/work_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/widget.dart';

void main() {
  testWidgets("With description", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) => const WorkResult.success(description: "Test description"),
      ),
    );
    expect(find.text("Test description"), findsOneWidget);
  });

  testWidgets("Without description", (tester) async {
    await tester.pumpWidget(Testable((_) => const WorkResult.success()));
    expect(find.byType(Text), findsNothing);
  });

  testWidgets("With description detail", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) => const WorkResult.success(
          description: "Test description",
          descriptionDetail: "Test description detail",
        ),
      ),
    );
    expect(find.text("Test description"), findsOneWidget);
    expect(find.text("Test description detail"), findsOneWidget);
  });

  testWidgets("Without description detail", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) => const WorkResult.success(description: "Test description"),
      ),
    );
    expect(find.byType(Text), findsOneWidget);
  });
}
