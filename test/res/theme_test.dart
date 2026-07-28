import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/res/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  setUp(() {
    AppConfig.reset();
  });

  testWidgets("colorTertiaryText is white30 in dark mode", (tester) async {
    AppConfig.get.init(
      appName: () => "Test App",
      themeMode: () => ThemeMode.dark,
    );
    var context = await buildContext(tester);
    expect(context.colorTertiaryText, Colors.white30);
  });

  testWidgets("colorTertiaryText is black38 in light mode", (tester) async {
    AppConfig.get.init(
      appName: () => "Test App",
      themeMode: () => ThemeMode.light,
    );
    var context = await buildContext(tester);
    expect(context.colorTertiaryText, Colors.black38);
  });
}
