import 'package:adair_flutter_lib/widgets/app_bar_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';

void main() {
  setUp(() async {
    await StubbedManagers.create();
  });

  testWidgets("Renders title text", (tester) async {
    await pumpContext(tester, (_) => const AppBarDropdown(title: "My Report"));
    expect(find.text("My Report"), findsOneWidget);
  });

  testWidgets("Renders dropdown arrow icon", (tester) async {
    await pumpContext(tester, (_) => const AppBarDropdown(title: "My Report"));
    expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
  });

  testWidgets("onTap callback fires on tap", (tester) async {
    var tapped = false;
    await pumpContext(
      tester,
      (_) => AppBarDropdown(title: "My Report", onTap: () => tapped = true),
    );
    await tester.tap(find.byType(AppBarDropdown));
    expect(tapped, isTrue);
  });

  testWidgets("Null onTap does not crash on tap", (tester) async {
    await pumpContext(tester, (_) => const AppBarDropdown(title: "My Report"));
    await tester.tap(find.byType(AppBarDropdown));
    expect(tester.takeException(), isNull);
  });

  testWidgets("textAlignment parameter is applied to Row", (tester) async {
    await pumpContext(
      tester,
      (_) => const AppBarDropdown(
        title: "My Report",
        textAlignment: MainAxisAlignment.start,
      ),
    );
    expect(
      tester.widget<Row>(find.byType(Row)).mainAxisAlignment,
      MainAxisAlignment.start,
    );
  });

  testWidgets("Custom padding is applied", (tester) async {
    const customPadding = EdgeInsets.all(12);
    await pumpContext(
      tester,
      (_) => const AppBarDropdown(title: "My Report", padding: customPadding),
    );

    expect(
      tester.widget<Padding>(find.byType(Padding).first).padding,
      customPadding,
    );
  });
}
