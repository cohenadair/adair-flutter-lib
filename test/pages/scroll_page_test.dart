import 'package:adair_flutter_lib/pages/scroll_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  testWidgets("Centered content", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) => const ScrollPage(centerContent: true, children: [Text("Test")]),
      ),
    );

    expect(find.byType(Center), findsOneWidget);
  });

  testWidgets("Not centered content", (tester) async {
    await tester.pumpWidget(
      Testable((_) => const ScrollPage(children: [Text("Test")])),
    );

    expect(find.byType(Center), findsNothing);
  });

  testWidgets("Includes refresh indicator", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) => ScrollPage(
          children: const [Text("Test")],
          onRefresh: () => Future.value(),
        ),
      ),
    );

    expect(find.byType(RefreshIndicator), findsOneWidget);
  });

  testWidgets("No refresh indicator", (tester) async {
    await tester.pumpWidget(
      Testable((_) => const ScrollPage(children: [Text("Test")])),
    );

    expect(find.byType(RefreshIndicator), findsNothing);
  });

  testWidgets("Default clip behavior when showing footer", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) => ScrollPage(
          footer: [TextButton(child: const Text("Tap Me"), onPressed: () {})],
          children: const [Text("Test")],
        ),
      ),
    );
    expect(
      tester
          .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
          .clipBehavior,
      Clip.hardEdge,
    );
  });

  testWidgets("No clip behavior with empty footer", (tester) async {
    await tester.pumpWidget(
      Testable((_) => const ScrollPage(footer: [], children: [Text("Test")])),
    );
    expect(
      tester
          .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
          .clipBehavior,
      Clip.none,
    );
  });

  testWidgets("Null footer buttons with empty input", (tester) async {
    await tester.pumpWidget(
      Testable((_) => const ScrollPage(footer: [], children: [Text("Test")])),
    );
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).persistentFooterButtons,
      isNull,
    );
  });

  testWidgets("Non-null footer buttons with valid input", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) => const ScrollPage(footer: [Text("A")], children: [Text("Test")]),
      ),
    );
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).persistentFooterButtons,
      isNotNull,
    );
  });

  testWidgets("Empty footer has always scroll physics", (tester) async {
    await tester.pumpWidget(
      Testable((_) => const ScrollPage(children: [Text("Test")])),
    );
    expect(
      tester
          .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
          .physics,
      isNotNull,
    );
  });

  testWidgets("Non-empty footer has no scroll physics", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) => const ScrollPage(footer: [Text("A")], children: [Text("Test")]),
      ),
    );
    expect(
      tester
          .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
          .physics,
      isNull,
    );
  });
}
