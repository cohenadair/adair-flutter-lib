import 'package:adair_flutter_lib/widgets/app_version.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();

    when(managers.packageInfoWrapper.fromPlatform()).thenAnswer(
      (_) => Future.value(
        PackageInfo(
          appName: "Test",
          packageName: "test.com",
          version: "2.3.4",
          buildNumber: "99",
        ),
      ),
    );
  });

  testWidgets("Version text renders when inListTile is false", (tester) async {
    await pumpContext(tester, (_) => const AppVersion());
    await tester.pumpAndSettle();

    expect(find.text("2.3.4 (99)"), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets("ListTile renders when inListTile is true", (tester) async {
    await pumpContext(tester, (_) => const AppVersion(inListTile: true));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text("2.3.4 (99)"), findsOneWidget);
  });

  testWidgets("Label appears in ListTile title when provided", (tester) async {
    await pumpContext(
      tester,
      (_) => const AppVersion(inListTile: true, label: "Version"),
    );
    await tester.pumpAndSettle();

    expect(find.text("Version"), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets("Label is absent from ListTile when null", (tester) async {
    await pumpContext(tester, (_) => const AppVersion(inListTile: true));
    await tester.pumpAndSettle();

    final tile = tester.widget<ListTile>(find.byType(ListTile));
    expect(tile.title, isNull);
  });

  testWidgets("Custom style is applied to version text", (tester) async {
    const customStyle = TextStyle(fontSize: 42);

    await pumpContext(tester, (_) => const AppVersion(style: customStyle));
    await tester.pumpAndSettle();

    final text = tester.widget<Text>(find.text("2.3.4 (99)"));
    expect(text.style, customStyle);
  });
}
