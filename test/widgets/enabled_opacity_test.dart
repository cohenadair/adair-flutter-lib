import 'package:adair_flutter_lib/widgets/enabled_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/finder.dart';
import '../test_utils/testable.dart';

void main() {
  testWidgets("isEnabled true renders full opacity", (tester) async {
    await pumpContext(
      tester,
      (_) => const EnabledOpacity(isEnabled: true, child: Text("test")),
    );

    expect(findFirst<Opacity>(tester).opacity, 1.0);
  });

  testWidgets("isEnabled false renders disabled opacity", (tester) async {
    await pumpContext(
      tester,
      (_) => const EnabledOpacity(isEnabled: false, child: Text("test")),
    );

    expect(findFirst<Opacity>(tester).opacity, 0.5);
  });
}
