import 'package:adair_flutter_lib/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  testWidgets("globalPosition returns null when key has no context", (
    tester,
  ) async {
    expect(GlobalKey().globalPosition(), isNull);
  });

  testWidgets("globalPosition returns rect matching size and offset", (
    tester,
  ) async {
    final key = GlobalKey();
    await pumpContext(
      tester,
      (_) => Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(key: key, height: 50.0, width: 75.0),
        ),
      ),
    );

    final position = key.globalPosition();
    expect(position, isNotNull);
    expect(position!.width, 75.0);
    expect(position.height, 50.0);
  });
}
