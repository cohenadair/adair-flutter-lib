import 'package:adair_flutter_lib/res/dimen.dart';
import 'package:adair_flutter_lib/widgets/empty_or.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/finder.dart';
import '../test_utils/testable.dart';

void main() {
  testWidgets("EmptyOr shows child", (tester) async {
    await tester.pumpWidget(
      Testable((_) => EmptyOr(isShowing: true, builder: (_) => Text("Test"))),
    );
    expect(find.text("Test"), findsOneWidget);
  });

  testWidgets("EmptyOr hides child", (tester) async {
    await tester.pumpWidget(
      Testable((_) => EmptyOr(isShowing: false, builder: (_) => Text("Test"))),
    );
    expect(find.text("Test"), findsNothing);
  });

  testWidgets("EmptyOr default padding", (tester) async {
    await tester.pumpWidget(
      Testable((_) => EmptyOr(builder: (_) => Text("Test"))),
    );
    expect(findFirst<Padding>(tester).padding, insetsZero);
  });

  testWidgets("EmptyOr custom padding", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) => EmptyOr(padding: insetsDefault, builder: (_) => Text("Test")),
      ),
    );
    expect(findFirst<Padding>(tester).padding, insetsDefault);
  });
}
