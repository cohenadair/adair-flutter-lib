import 'package:adair_flutter_lib/widgets/autocomplete_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  testWidgets("Widget renders without errors", (tester) async {
    await pumpContext(
      tester,
      (_) => AutocompleteTextInput<String>(
        optionsBuilder: (_) => const Iterable.empty(),
        displayStringForOption: (s) => s,
        onSelected: (_) {},
      ),
    );

    expect(find.byType(AutocompleteTextInput<String>), findsOneWidget);
  });

  testWidgets("Label is displayed", (tester) async {
    await pumpContext(
      tester,
      (_) => AutocompleteTextInput<String>(
        label: "Search",
        optionsBuilder: (_) => const Iterable.empty(),
        displayStringForOption: (s) => s,
        onSelected: (_) {},
      ),
    );

    expect(find.text("Search"), findsOneWidget);
  });

  testWidgets("Options are shown when optionsBuilder returns results", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (_) => AutocompleteTextInput<String>(
        optionsBuilder: (_) => const ["Apple"],
        displayStringForOption: (s) => s,
        onSelected: (_) {},
      ),
    );

    await tester.enterText(find.byType(TextFormField), "a");
    await tester.pumpAndSettle();

    expect(find.text("Apple"), findsOneWidget);
  });

  testWidgets("Tapping an option fires onSelected with the option", (
    tester,
  ) async {
    String? selected;

    await pumpContext(
      tester,
      (_) => AutocompleteTextInput<String>(
        optionsBuilder: (_) => const ["Apple"],
        displayStringForOption: (s) => s,
        onSelected: (s) => selected = s,
      ),
    );

    await tester.enterText(find.byType(TextFormField), "a");
    await tester.pumpAndSettle();
    await tester.tap(find.text("Apple"));
    await tester.pumpAndSettle();

    expect(selected, "Apple");
  });

  testWidgets("Editing field after selection fires onSelected with null", (
    tester,
  ) async {
    String? selected = "initial";

    await pumpContext(
      tester,
      (_) => AutocompleteTextInput<String>(
        optionsBuilder: (_) => const ["Apple"],
        displayStringForOption: (s) => s,
        onSelected: (s) => selected = s,
      ),
    );

    await tester.enterText(find.byType(TextFormField), "a");
    await tester.pumpAndSettle();
    await tester.tap(find.text("Apple"));
    await tester.pumpAndSettle();
    expect(selected, "Apple");

    await tester.enterText(find.byType(TextFormField), "something else");
    await tester.pumpAndSettle();

    expect(selected, isNull);
  });

  testWidgets(
    "Editing field without prior selection does not fire onSelected",
    (tester) async {
      var callCount = 0;

      await pumpContext(
        tester,
        (_) => AutocompleteTextInput<String>(
          optionsBuilder: (_) => const ["Apple"],
          displayStringForOption: (s) => s,
          onSelected: (_) => callCount++,
        ),
      );

      await tester.enterText(find.byType(TextFormField), "anything");
      await tester.pumpAndSettle();

      expect(callCount, 0);
    },
  );

  testWidgets("itemBuilder is used when provided", (tester) async {
    await pumpContext(
      tester,
      (_) => AutocompleteTextInput<String>(
        optionsBuilder: (_) => const ["Apple"],
        displayStringForOption: (s) => s,
        onSelected: (_) {},
        itemBuilder: (_, option) => Text("Custom: $option"),
      ),
    );

    await tester.enterText(find.byType(TextFormField), "a");
    await tester.pumpAndSettle();

    expect(find.text("Custom: Apple"), findsOneWidget);
  });

  testWidgets("Default item uses displayStringForOption when no itemBuilder", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (_) => AutocompleteTextInput<String>(
        optionsBuilder: (_) => const ["Apple"],
        displayStringForOption: (s) => "Display: $s",
        onSelected: (_) {},
      ),
    );

    await tester.enterText(find.byType(TextFormField), "a");
    await tester.pumpAndSettle();

    expect(find.text("Display: Apple"), findsOneWidget);
  });

  testWidgets("initialValue pre-fills the text field", (tester) async {
    await pumpContext(
      tester,
      (_) => AutocompleteTextInput<String>(
        optionsBuilder: (_) => const Iterable.empty(),
        displayStringForOption: (s) => s,
        onSelected: (_) {},
        initialValue: "pre-filled",
      ),
    );

    expect(find.widgetWithText(TextFormField, "pre-filled"), findsOneWidget);
  });

  testWidgets("Editing field after initialValue fires onSelected with null", (
    tester,
  ) async {
    String? selected = "not yet called";

    await pumpContext(
      tester,
      (_) => AutocompleteTextInput<String>(
        optionsBuilder: (_) => const ["Apple"],
        displayStringForOption: (s) => s,
        onSelected: (s) => selected = s,
        initialValue: "Apple",
      ),
    );

    await tester.enterText(find.byType(TextFormField), "something else");
    await tester.pumpAndSettle();

    expect(selected, isNull);
  });

  testWidgets(
    "onTextChanged is called on every keystroke with the current text",
    (tester) async {
      final values = <String>[];
      await pumpContext(
        tester,
        (_) => AutocompleteTextInput<String>(
          optionsBuilder: (_) => const Iterable.empty(),
          displayStringForOption: (s) => s,
          onSelected: (_) {},
          onTextChanged: values.add,
        ),
      );

      await tester.enterText(find.byType(TextFormField), "ab");
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), "cd");
      await tester.pumpAndSettle();

      expect(values, ["ab", "cd"]);
    },
  );

  testWidgets(
    "onTextChanged is not called on initial pump before any keystroke",
    (tester) async {
      var callCount = 0;
      await pumpContext(
        tester,
        (_) => AutocompleteTextInput<String>(
          optionsBuilder: (_) => const Iterable.empty(),
          displayStringForOption: (s) => s,
          onSelected: (_) {},
          onTextChanged: (_) => callCount++,
        ),
      );

      expect(callCount, 0);
    },
  );

  test(
    "filterOptionsBuilder returns all options when input is empty",
    () async {
      final builder = AutocompleteTextInput.filterOptionsBuilder<String>([
        "Apple",
        "Banana",
      ], (s) => s);
      final result = await builder(const TextEditingValue(text: ""));
      expect(result.toList(), ["Apple", "Banana"]);
    },
  );

  test("filterOptionsBuilder filters options by searchString", () async {
    final builder = AutocompleteTextInput.filterOptionsBuilder<String>([
      "Apple",
      "Banana",
    ], (s) => s);
    final result = await builder(const TextEditingValue(text: "app"));
    expect(result.toList(), ["Apple"]);
  });

  test("filterOptionsBuilder returns empty when no options match", () async {
    final builder = AutocompleteTextInput.filterOptionsBuilder<String>([
      "Apple",
      "Banana",
    ], (s) => s);
    final result = await builder(const TextEditingValue(text: "xyz"));
    expect(result.toList(), isEmpty);
  });

  test(
    "filterOptionsBuilder uses searchString to match, not the option itself",
    () async {
      final options = [MapEntry("1", "Red"), MapEntry("2", "Blue")];
      final builder =
          AutocompleteTextInput.filterOptionsBuilder<MapEntry<String, String>>(
            options,
            (e) => e.value,
          );
      final result = await builder(const TextEditingValue(text: "blu"));
      expect(result.map((e) => e.value).toList(), ["Blue"]);
    },
  );
}
