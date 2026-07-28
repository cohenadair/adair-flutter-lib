import 'package:adair_flutter_lib/res/style.dart';
import 'package:adair_flutter_lib/widgets/input_controller.dart';
import 'package:adair_flutter_lib/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  testWidgets("onChanged callback is invoked", (tester) async {
    var changed = false;
    await tester.pumpWidget(
      Testable(
        (context) => TextInput.name(
          context,
          controller: TextInputController(),
          onChanged: (_) => changed = true,
        ),
      ),
    );
    await tester.enterText(find.byType(TextInput), "Input");
    await tester.pumpAndSettle();
    expect(changed, isTrue);
  });

  testWidgets("Disabled input has disabled text style", (tester) async {
    var context = await pumpContext(
      tester,
      (context) => TextInput.name(
        context,
        controller: TextInputController()..value = "Input",
        onChanged: (_) => {},
        isEnabled: false,
      ),
    );

    var formField = tester.widget<TextField>(find.byType(TextField));
    expect(formField.style, styleDisabled(context));
  });

  testWidgets(
    "TextInput.description with hasMaxLength false has no maxLength",
    (tester) async {
      await tester.pumpWidget(
        Testable(
          (context) => TextInput.description(
            context,
            controller: TextInputController(),
            hasMaxLength: false,
          ),
        ),
      );

      var formField = tester.widget<TextField>(find.byType(TextField));
      expect(formField.maxLength, isNull);
    },
  );

  testWidgets(
    "TextInput.description with hasMaxLength true has a maxLength of 500",
    (tester) async {
      await tester.pumpWidget(
        Testable(
          (context) => TextInput.description(
            context,
            controller: TextInputController(),
            hasMaxLength: true,
          ),
        ),
      );

      var formField = tester.widget<TextField>(find.byType(TextField));
      expect(formField.maxLength, 500);
    },
  );

  testWidgets("TextInput.description with expands false does not expand", (
    tester,
  ) async {
    await tester.pumpWidget(
      Testable(
        (context) => TextInput.description(
          context,
          controller: TextInputController(),
          expands: false,
        ),
      ),
    );

    var formField = tester.widget<TextField>(find.byType(TextField));
    expect(formField.expands, isFalse);
    expect(formField.textAlignVertical, isNull);
    expect(formField.decoration?.alignLabelWithHint, isFalse);
  });

  testWidgets(
    "TextInput.description with expands true expands to fill its parent",
    (tester) async {
      await tester.pumpWidget(
        Testable(
          (context) => TextInput.description(
            context,
            controller: TextInputController(),
            expands: true,
          ),
        ),
      );

      var formField = tester.widget<TextField>(find.byType(TextField));
      expect(formField.expands, isTrue);
      expect(formField.textAlignVertical, TextAlignVertical.top);
      expect(formField.decoration?.alignLabelWithHint, isTrue);
    },
  );

  testWidgets(
    "TextInput with expands true overrides an explicit maxLines to null",
    (tester) async {
      await tester.pumpWidget(
        Testable(
          (_) => TextInput(
            controller: TextInputController(),
            expands: true,
            maxLines: 5,
          ),
        ),
      );

      var formField = tester.widget<TextField>(find.byType(TextField));
      expect(formField.maxLines, isNull);
    },
  );
}
