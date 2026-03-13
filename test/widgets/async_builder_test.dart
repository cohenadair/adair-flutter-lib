import 'dart:async';

import 'package:adair_flutter_lib/widgets/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  testWidgets("Loading widget shows while future is working", (tester) async {
    await pumpContext(
      tester,
      (_) => AsyncBuilder<bool>.future(
        future: Future.delayed(
          const Duration(milliseconds: 50),
          () => Future.value(true),
        ),
        errorReason: "Error",
        loadingBuilder: (_) => Text("Loading..."),
        builder: (_, _) => Text("Test Text"),
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
      (_) => AsyncBuilder<bool>.future(
        future: Future.delayed(
          const Duration(milliseconds: 50),
          () => Future.value(true),
        ),
        errorReason: "Error",
        builder: (_, _) => Text("Test Text"),
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
      (_) => AsyncBuilder<bool>.future(
        future: Future.delayed(
          const Duration(milliseconds: 50),
          () => throw Exception("Test exception"),
        ),
        errorReason: "Testing error",
        builder: (_, _) => Text("Test Text"),
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
      (_) => AsyncBuilder<bool>.future(
        future: Future.delayed(
          const Duration(milliseconds: 50),
          () => throw Exception("Test exception"),
        ),
        errorReason: "Testing error",
        builder: (_, _) => Text("Test Text"),
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
      (_) => AsyncBuilder<bool>.future(
        future: Future.delayed(
          const Duration(milliseconds: 50),
          () => throw Exception("Test exception"),
        ),
        errorReason: "Testing error",
        builder: (_, _) => Text("Test Text"),
      ),
    );
    // Finish future.
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(SizedBox), findsOneWidget);
    expect(find.text("Test Text"), findsNothing);
  });

  testWidgets("Successful Future widget is rendered", (tester) async {
    await pumpContext(
      tester,
      (_) => AsyncBuilder<bool>.future(
        future: Future.value(true),
        errorReason: "Error",
        builder: (_, data) => Text("$data"),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text("true"), findsOneWidget);
  });

  testWidgets("Stream is loading", (tester) async {
    final controller = StreamController<bool>();
    addTearDown(controller.close);

    await pumpContext(
      tester,
      (_) => AsyncBuilder<bool>.stream(
        stream: controller.stream,
        errorReason: "Error",
        loadingBuilder: (_) => Text("Loading..."),
        builder: (_, _) => Text("Test Text"),
      ),
    );
    expect(find.text("Loading..."), findsOneWidget);
    expect(find.text("Test Text"), findsNothing);

    controller.add(true);
    await tester.pumpAndSettle();
    expect(find.text("Loading..."), findsNothing);
    expect(find.text("Test Text"), findsOneWidget);
  });

  testWidgets("Successful Stream widget is rendered", (tester) async {
    await pumpContext(
      tester,
      (_) => AsyncBuilder<bool>.stream(
        stream: Stream.value(true),
        errorReason: "Error",
        builder: (_, data) => Text("$data"),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text("true"), findsOneWidget);
  });
}
