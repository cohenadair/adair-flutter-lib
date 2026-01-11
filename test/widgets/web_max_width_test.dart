import 'package:adair_flutter_lib/widgets/web_max_width.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
  });

  testWidgets("Child-only is rendered for non-web platforms", (tester) async {
    when(managers.ioWrapper.isWeb).thenReturn(false);
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1.0;

    await pumpContext(
      tester,
          (_) => WebMaxWidth(child: TextField()),
    );
    expect(tester.getSize(find.byType(TextField)).width, 1600);
  });

  testWidgets("Width is restricted on web", (tester) async {
    when(managers.ioWrapper.isWeb).thenReturn(true);
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1.0;

    await pumpContext(
      tester,
      (_) => WebMaxWidth(child: TextField()),
    );
    expect(tester.getSize(find.byType(TextField)).width, 500);
  });
}
