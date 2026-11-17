import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/widgets/button.dart';
import 'package:adair_flutter_lib/widgets/month_year_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/timezone.dart';

import '../test_utils/finder.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';
import '../test_utils/widget.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
    managers.stubCurrentTime(DateTime(2022, 10, 15));
  });

  void verifyMonth(WidgetTester tester, String month, Color color) {
    expect(
      (findFirstWithText<AnimatedContainer>(tester, month).decoration
              as BoxDecoration)
          .color,
      color,
    );
  }

  Future<void> openPicker(WidgetTester tester) async {
    await pumpContext(
      tester,
      (context) => Scaffold(
        body: Button(
          text: "Test",
          onPressed: () => showMonthYearPicker(context),
        ),
      ),
    );
    await tapAndSettle(tester, find.text("TEST"));
  }

  Color? monthTextColor(WidgetTester tester, String month) {
    return tester
        .widget<AnimatedDefaultTextStyle>(
          find
              .ancestor(
                of: find.text(month),
                matching: find.byType(AnimatedDefaultTextStyle),
              )
              .first,
        )
        .style
        .color;
  }

  testWidgets("Changing year", (tester) async {
    await openPicker(tester);
    expect(find.text("2022"), findsOneWidget);

    await tapAndSettle(tester, find.byIcon(Icons.chevron_left));
    expect(find.text("2022"), findsNothing);
    expect(find.text("2021"), findsOneWidget);

    await tapAndSettle(tester, find.byIcon(Icons.chevron_right));
    await tapAndSettle(tester, find.byIcon(Icons.chevron_right));
    expect(find.text("2022"), findsNothing);
    expect(find.text("2021"), findsNothing);
    expect(find.text("2023"), findsOneWidget);
  });

  testWidgets("Year text uses the app bar content color", (tester) async {
    when(managers.appConfig.colorAppBarContent).thenReturn((_) => Colors.red);
    await openPicker(tester);
    expect(tester.widget<Text>(find.text("2022")).style?.color, Colors.red);
  });

  testWidgets("Selected month text uses the app bar content color", (
    tester,
  ) async {
    when(managers.appConfig.colorAppBarContent).thenReturn((_) => Colors.red);
    await openPicker(tester);
    expect(monthTextColor(tester, "Oct"), Colors.red);
  });

  testWidgets("Unselected month text uses the default color", (tester) async {
    when(managers.appConfig.colorAppBarContent).thenReturn((_) => Colors.red);
    await openPicker(tester);
    expect(monthTextColor(tester, "Mar"), isNot(Colors.red));
  });

  testWidgets("Changing month", (tester) async {
    await openPicker(tester);
    verifyMonth(tester, "Oct", AppConfig.get.colorAppTheme);

    await tapAndSettle(tester, find.text("Mar"));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    verifyMonth(tester, "Oct", Colors.transparent);
    verifyMonth(tester, "Mar", AppConfig.get.colorAppTheme);
  });

  testWidgets("Opens to initialDate instead of today", (tester) async {
    await pumpContext(
      tester,
      (context) => Scaffold(
        body: Button(
          text: "Test",
          onPressed: () =>
              showMonthYearPicker(context, initialDate: DateTime(2019, 6)),
        ),
      ),
    );

    await tapAndSettle(tester, find.text("TEST"));
    expect(find.text("2019"), findsOneWidget);
    verifyMonth(tester, "Jun", AppConfig.get.colorAppTheme);
  });

  testWidgets("Non-null result", (tester) async {
    TZDateTime? result;
    await pumpContext(
      tester,
      (context) => Scaffold(
        body: Button(
          text: "Test",
          onPressed: () async {
            result = await showMonthYearPicker(context);
          },
        ),
      ),
    );

    await tapAndSettle(tester, find.text("TEST"));
    await tapAndSettle(tester, find.text("Mar"));
    await tapAndSettle(tester, find.byIcon(Icons.chevron_left));
    await tapAndSettle(tester, find.text("OK"));

    expect(result, isNotNull);
    expect(result!.year, 2021);
    expect(result!.month, 3);
  });

  testWidgets("Null result", (tester) async {
    TZDateTime? result;
    await pumpContext(
      tester,
      (context) => Scaffold(
        body: Button(
          text: "Test",
          onPressed: () async {
            result = await showMonthYearPicker(context);
          },
        ),
      ),
    );

    await tapAndSettle(tester, find.text("TEST"));
    await tapAndSettle(tester, find.text("Mar"));
    await tapAndSettle(tester, find.byIcon(Icons.chevron_left));
    await tapAndSettle(tester, find.text("CANCEL"));

    expect(result, isNull);
  });
}
