import 'package:adair_flutter_lib/widgets/restricted_width.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  testWidgets("Child-only is rendered for smaller screens", (tester) async {
    tester.view.physicalSize = const Size(500, 900);
    tester.view.devicePixelRatio = 1.0;

    await pumpContext(tester, (_) => RestrictedWidth(child: TextField()));
    expect(tester.getSize(find.byType(TextField)).width, 500);
  });

  testWidgets("Width is restricted on larger", (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1.0;

    await pumpContext(tester, (_) => RestrictedWidth(child: TextField()));
    expect(tester.getSize(find.byType(TextField)).width, 500);
  });
}
