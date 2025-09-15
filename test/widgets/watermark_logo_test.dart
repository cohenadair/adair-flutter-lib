import 'package:adair_flutter_lib/widgets/title_text.dart';
import 'package:adair_flutter_lib/widgets/watermark_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';

void main() {
  setUp(() async {
    await StubbedManagers.create(); // For theme mode.
  });

  testWidgets("WatermarkLogo with title", (tester) async {
    await pumpContext(
      tester,
      (_) => const WatermarkLogo(icon: Icons.add, title: "Title"),
    );
    expect(find.byType(TitleText), findsOneWidget);
  });

  testWidgets("WatermarkLogo without title", (tester) async {
    await pumpContext(tester, (_) => const WatermarkLogo(icon: Icons.add));
    expect(find.byType(TitleText), findsNothing);
  });
}
