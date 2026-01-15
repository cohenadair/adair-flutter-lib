import 'package:adair_flutter_lib/pages/landing_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
  });

  testWidgets("Error is shown", (tester) async {
    await tester.pumpWidget(
      Testable((context) => const LandingPage(hasError: false)),
    );
    expect(find.byType(Align), findsNWidgets(2));
  });

  testWidgets("Error is hidden", (tester) async {
    await tester.pumpWidget(
      Testable((context) => const LandingPage(hasError: true)),
    );
    expect(find.byType(Align), findsNWidgets(3));
  });

  testWidgets("Company name is shown", (tester) async {
    await tester.pumpWidget(
      Testable((context) => const LandingPage(hasError: false)),
    );
    expect(find.text("Test, Inc."), findsOneWidget);
  });

  testWidgets("Company name is hidden", (tester) async {
    when(managers.appConfig.companyName).thenReturn(null);
    await tester.pumpWidget(
      Testable((context) => const LandingPage(hasError: false)),
    );
    expect(find.text("Test, Inc."), findsNothing);
  });
}
