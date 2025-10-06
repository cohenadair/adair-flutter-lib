import 'package:adair_flutter_lib/widgets/safe_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  testWidgets("Loading widget shows while future is working", (tester) async {
    await pumpContext(
      tester,
      (_) => SafeFutureBuilder<bool>(
        future: Future.delayed(
          const Duration(milliseconds: 50),
          () => Future.value(true),
        ),
        errorReason: "Error",
        loadingBuilder: (_) => Text("Loading..."),
        builder: (_, __) => Text("Test Text"),
      ),
    );
    expect(find.text("Loading..."), findsOneWidget);
    expect(find.text("Test Text"), findsNothing);

    // Finish future.
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets("SidedBox shows while future is working", (tester) async {
    await pumpContext(
      tester,
      (_) => SafeFutureBuilder<bool>(
        future: Future.delayed(
          const Duration(milliseconds: 50),
          () => Future.value(true),
        ),
        errorReason: "Error",
        builder: (_, __) => Text("Test Text"),
      ),
    );
    expect(find.byType(SizedBox), findsOneWidget);
    expect(find.text("Test Text"), findsNothing);

    // Finish future.
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets("Error widget is rendered", (tester) async {
    await pumpContext(
      tester,
      (_) => SafeFutureBuilder<bool>(
        future: Future.delayed(
          const Duration(milliseconds: 50),
          () => throw Exception("Test exception"),
        ),
        errorReason: "Testing error",
        builder: (_, __) => Text("Test Text"),
        loadingBuilder: (_) => Text("Loading..."),
        errorBuilder: (_) => Text("Test error"),
      ),
    );
    // Finish future.
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text("Loading..."), findsNothing);
    expect(find.text("Test error"), findsOneWidget);
    expect(find.byType(SizedBox), findsNothing);
    expect(find.text("Test Text"), findsNothing);
  });

  testWidgets("Loading widget is rendered on error", (tester) async {
    await pumpContext(
      tester,
      (_) => SafeFutureBuilder<bool>(
        future: Future.delayed(
          const Duration(milliseconds: 50),
          () => throw Exception("Test exception"),
        ),
        errorReason: "Testing error",
        builder: (_, __) => Text("Test Text"),
        loadingBuilder: (_) => Text("Loading..."),
      ),
    );
    // Finish future.
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text("Loading..."), findsOneWidget);
    expect(find.byType(SizedBox), findsNothing);
    expect(find.text("Test Text"), findsNothing);
  });

  testWidgets("SizedBox is rendered on error", (tester) async {
    await pumpContext(
      tester,
      (_) => SafeFutureBuilder<bool>(
        future: Future.delayed(
          const Duration(milliseconds: 50),
          () => throw Exception("Test exception"),
        ),
        errorReason: "Testing error",
        builder: (_, __) => Text("Test Text"),
      ),
    );
    // Finish future.
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(SizedBox), findsOneWidget);
    expect(find.text("Test Text"), findsNothing);
  });

  testWidgets("Successful widget is rendered", (tester) async {
    // TODO
  });
}
