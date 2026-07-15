import 'package:adair_flutter_lib/widgets/min_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/finder.dart';
import '../test_utils/testable.dart';

void main() {
  testWidgets("width is null renders a Divider", (tester) async {
    await pumpContext(tester, (_) => const MinDivider(color: Colors.red));
    expect(find.byType(Divider), findsOneWidget);
  });

  testWidgets(
    "width is null and color is provided uses that color on the Divider",
    (tester) async {
      await pumpContext(tester, (_) => const MinDivider(color: Colors.red));
      expect(findFirst<Divider>(tester).color, Colors.red);
    },
  );

  testWidgets(
    "width and color are null renders a Divider using theme divider color",
    (tester) async {
      await pumpContext(
        tester,
        (_) => Theme(
          data: ThemeData(dividerColor: Colors.blue),
          child: const MinDivider(),
        ),
      );
      expect(findFirst<Divider>(tester).color, Colors.blue);
    },
  );

  testWidgets("width is not null renders no Divider widget", (tester) async {
    await pumpContext(
      tester,
      (_) => const MinDivider(color: Colors.blue, width: 80),
    );
    expect(find.byType(Divider), findsNothing);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets(
    "width is not null and color is provided uses that color on the Container",
    (tester) async {
      await pumpContext(
        tester,
        (_) => const MinDivider(color: Colors.blue, width: 80),
      );
      expect(findFirst<Container>(tester).color, Colors.blue);
    },
  );

  testWidgets(
    "width is not null and color is null renders a Container using theme divider color",
    (tester) async {
      await pumpContext(
        tester,
        (_) => Theme(
          data: ThemeData(dividerColor: Colors.blue),
          child: const MinDivider(width: 80),
        ),
      );
      expect(findFirst<Container>(tester).color, Colors.blue);
    },
  );
}
