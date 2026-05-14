import 'package:adair_flutter_lib/widgets/nav_rail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/finder.dart';
import '../test_utils/testable.dart';

void main() {
  testWidgets("Renders child widget", (tester) async {
    await pumpContext(
      tester,
      (_) => const NavRailContent(child: Text("hello")),
    );
    expect(find.text("hello"), findsOneWidget);
  });

  testWidgets("Contains a ClipRRect", (tester) async {
    await pumpContext(
      tester,
      (_) => const NavRailContent(child: Text("hello")),
    );
    expect(find.byType(ClipRRect), findsOneWidget);
  });

  testWidgets(
    "Uses colorScheme surface color when navigationRailTheme backgroundColor is null",
    (tester) async {
      const surfaceColor = Color(0xFFAABBCC);
      await pumpContext(
        tester,
        (ctx) => Theme(
          data: Theme.of(ctx).copyWith(
            navigationRailTheme: const NavigationRailThemeData(
              backgroundColor: null,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
            ).copyWith(surface: surfaceColor),
          ),
          child: const NavRailContent(child: Text("hello")),
        ),
      );
      expect(findFirst<Container>(tester).color, surfaceColor);
    },
  );

  testWidgets("Uses navigationRailTheme backgroundColor when set", (
    tester,
  ) async {
    const bgColor = Color(0xFF112233);
    await pumpContext(
      tester,
      (ctx) => Theme(
        data: Theme.of(ctx).copyWith(
          navigationRailTheme: const NavigationRailThemeData(
            backgroundColor: bgColor,
          ),
        ),
        child: const NavRailContent(child: Text("hello")),
      ),
    );
    expect(findFirst<Container>(tester).color, bgColor);
  });
}
