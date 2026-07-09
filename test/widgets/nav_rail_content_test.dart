import 'package:adair_flutter_lib/widgets/nav_rail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  // NavRailContent wraps its ClipRRect in a Material that carries the
  // themed background color; Testable itself also wraps everything in an
  // outer Material, so this must be scoped to the one that's an ancestor
  // of the ClipRRect rather than matched by type alone.
  Material outerMaterial(WidgetTester tester) => tester.widget<Material>(
    find
        .ancestor(of: find.byType(ClipRRect), matching: find.byType(Material))
        .first,
  );

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
      expect(outerMaterial(tester).color, surfaceColor);
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
    expect(outerMaterial(tester).color, bgColor);
  });
}
