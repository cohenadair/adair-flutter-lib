import 'package:adair_flutter_lib/widgets/animated_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  testWidgets("Default visible uses visibleOpacity of 1.0 as opacity", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (_) => const AnimatedVisibility(child: Text("hello")),
    );

    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      1.0,
    );
  });

  testWidgets("Visible false sets opacity to 0.0", (tester) async {
    await pumpContext(
      tester,
      (_) => const AnimatedVisibility(isVisible: false, child: Text("hello")),
    );

    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      0.0,
    );
  });

  testWidgets("Visible true with custom visibleOpacity uses that value", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (_) =>
          const AnimatedVisibility(visibleOpacity: 0.5, child: Text("hello")),
    );

    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      0.5,
    );
  });
}
