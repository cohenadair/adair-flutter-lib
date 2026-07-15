import 'package:adair_flutter_lib/widgets/empty_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/finder.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';

void main() {
  setUp(() async {
    await StubbedManagers.create();
  });

  Future<void> pumpView(WidgetTester tester) => pumpContext(
    tester,
    (_) => const EmptyStateView(
      icon: Icons.star,
      iconSize: 48,
      title: "Title",
      description: "Description",
    ),
  );

  testWidgets("Icon renders with given icon and size", (tester) async {
    await pumpView(tester);

    var icon = findFirst<Icon>(tester);
    expect(icon.icon, Icons.star);
    expect(icon.size, 48);
  });

  testWidgets("Title text renders with given string", (tester) async {
    await pumpView(tester);

    expect(find.text("Title"), findsOneWidget);
  });

  testWidgets("Description text renders centered", (tester) async {
    await pumpView(tester);

    expect(
      tester.widget<Text>(find.text("Description")).textAlign,
      TextAlign.center,
    );
  });
}
