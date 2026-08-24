import 'package:adair_flutter_lib/res/theme.dart';
import 'package:adair_flutter_lib/widgets/tinted_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/testable.dart';

void main() {
  testWidgets("Defaults to context.colorApp when color is not given", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (_) => const TintedSvgPicture("assets/logo.svg"),
      theme: ThemeData(
        extensions: [const AdairFlutterLibThemeExtension(app: Colors.teal)],
      ),
    );

    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(
      svg.colorFilter,
      const ColorFilter.mode(Colors.teal, BlendMode.srcIn),
    );
  });

  testWidgets("Uses the given color when provided", (tester) async {
    await pumpContext(
      tester,
      (_) => const TintedSvgPicture("assets/logo.svg", color: Colors.red),
    );

    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(
      svg.colorFilter,
      const ColorFilter.mode(Colors.red, BlendMode.srcIn),
    );
  });

  // SvgPicture builds its own internal SizedBox, so a bare
  // find.byType(SizedBox) would also match that descendant. Scoping to an
  // ancestor of the SvgPicture isolates TintedSvgPicture's own wrapping
  // SizedBox.
  SizedBox findWrappingSizedBox(WidgetTester tester) => tester.widget<SizedBox>(
    find
        .ancestor(of: find.byType(SvgPicture), matching: find.byType(SizedBox))
        .first,
  );

  testWidgets("Passes maxHeight through to the wrapping SizedBox", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (_) => const TintedSvgPicture("assets/logo.svg", maxHeight: 42),
    );

    expect(findWrappingSizedBox(tester).height, 42);
  });

  testWidgets("Passes maxWidth through to the wrapping SizedBox", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (_) => const TintedSvgPicture("assets/logo.svg", maxWidth: 42),
    );

    expect(findWrappingSizedBox(tester).width, 42);
  });

  testWidgets("Returns the bare SvgPicture when no max size is given", (
    tester,
  ) async {
    await pumpContext(tester, (_) => const TintedSvgPicture("assets/logo.svg"));

    expect(
      find.ancestor(
        of: find.byType(SvgPicture),
        matching: find.byType(SizedBox),
      ),
      findsNothing,
    );
    expect(
      find.ancestor(
        of: find.byType(SvgPicture),
        matching: find.byType(FittedBox),
      ),
      findsNothing,
    );
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets("Defaults to center alignment on the wrapping FittedBox", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (_) => const TintedSvgPicture("assets/logo.svg", maxHeight: 42),
    );

    final box = tester.widget<FittedBox>(find.byType(FittedBox));
    expect(box.alignment, Alignment.center);
  });

  testWidgets("Passes the given alignment through to the wrapping FittedBox", (
    tester,
  ) async {
    await pumpContext(
      tester,
      (_) => const TintedSvgPicture(
        "assets/logo.svg",
        maxHeight: 42,
        alignment: Alignment.centerLeft,
      ),
    );

    final box = tester.widget<FittedBox>(find.byType(FittedBox));
    expect(box.alignment, Alignment.centerLeft);
  });
}
