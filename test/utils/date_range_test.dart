import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:adair_flutter_lib/model/gen/adair_flutter_lib.pb.dart';
import 'package:adair_flutter_lib/utils/date_range.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/timezone.dart';

import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
  });

  Int64 msSinceEpoch(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
  ]) {
    return Int64(
      TimeManager.get
          .dateTimeFromValues(year, month, day, hour, minute)
          .millisecondsSinceEpoch,
    );
  }

  void assertStatsDateRange(
    WidgetTester tester, {
    required DateRange dateRange,
    required TZDateTime now,
    required TZDateTime expectedStart,
    TZDateTime? expectedEnd,
  }) {
    when(managers.timeManager.now(any)).thenReturn(now);
    when(managers.timeManager.now()).thenReturn(now);

    dateRange.timeZone = TimeManager.get.currentTimeZone;
    expect(dateRange.startDate, equals(expectedStart));
    expect(
      dateRange.endDate,
      equals(expectedEnd ?? TimeManager.get.now(dateRange.timeZone)),
    );
  }

  test("Days calculated correctly", () {
    DateRange range = DateRange(
      startTimestamp: msSinceEpoch(2019, 1, 1),
      endTimestamp: msSinceEpoch(2019, 2, 1),
    );

    expect(range.days, equals(31));

    range = DateRange(
      startTimestamp: msSinceEpoch(2019, 1, 1),
      endTimestamp: msSinceEpoch(2019, 1, 10),
    );

    expect(range.days, equals(9));

    range = DateRange(
      startTimestamp: msSinceEpoch(2019, 1, 1),
      endTimestamp: msSinceEpoch(2019, 1, 1),
    );

    expect(range.days, equals(0));

    range = DateRange(
      startTimestamp: msSinceEpoch(2019, 1, 1),
      endTimestamp: msSinceEpoch(2019, 1, 1, 15, 30),
    );

    expect(range.days, equals(0.6458333333333334));
  });

  test("Weeks calculated correctly", () {
    DateRange range = DateRange(
      startTimestamp: msSinceEpoch(2019, 1, 1),
      endTimestamp: msSinceEpoch(2019, 2, 1),
    );

    expect(range.weeks, equals(4.428571428571429));

    range = DateRange(
      startTimestamp: msSinceEpoch(2019, 1, 1),
      endTimestamp: msSinceEpoch(2019, 3, 10),
    );

    expect(range.weeks, equals(9.714285714285714));

    range = DateRange(
      startTimestamp: msSinceEpoch(2019, 1, 1),
      endTimestamp: msSinceEpoch(2019, 1, 1),
    );

    expect(range.weeks, equals(0));

    range = DateRange(
      startTimestamp: msSinceEpoch(2019, 1, 1),
      endTimestamp: msSinceEpoch(2019, 1, 4),
    );

    expect(range.weeks, equals(0.42857142857142855));
  });

  test("Months calculated correctly", () {
    DateRange range = DateRange(
      startTimestamp: msSinceEpoch(2019, 1, 1),
      endTimestamp: msSinceEpoch(2019, 2, 1),
    );

    expect(range.months, equals(1.0333333333333334));

    range = DateRange(
      startTimestamp: msSinceEpoch(2019, 1, 1),
      endTimestamp: msSinceEpoch(2019, 3, 10),
    );

    expect(range.months, equals(2.2666666666666666));

    range = DateRange(
      startTimestamp: msSinceEpoch(2019, 1, 1),
      endTimestamp: msSinceEpoch(2019, 1, 1),
    );

    expect(range.months, equals(0));

    range = DateRange(
      startTimestamp: msSinceEpoch(2019, 1, 1),
      endTimestamp: msSinceEpoch(2019, 1, 20),
    );

    expect(range.months, equals(0.6333333333333333));
  });

  testWidgets("Today", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.today),
      now: TimeManager.get.dateTimeFromValues(2019, 1, 15, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 1, 15),
    );
  });

  testWidgets("Yesterday", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.yesterday),
      now: TimeManager.get.dateTimeFromValues(2019, 1, 15, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 1, 14),
      expectedEnd: TimeManager.get.dateTimeFromValues(2019, 1, 15),
    );
  });

  testWidgets("This week - year overlap", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisWeek),
      now: TimeManager.get.dateTimeFromValues(2019, 1, 3, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2018, 12, 31, 0, 0, 0),
    );
  });

  testWidgets("This week - within the same month", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisWeek),
      now: TimeManager.get.dateTimeFromValues(2019, 2, 13, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 2, 11, 0, 0, 0),
    );
  });

  testWidgets("This week - same day as week start", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisWeek),
      now: TimeManager.get.dateTimeFromValues(2019, 2, 4, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 2, 4, 0, 0, 0),
    );
  });

  testWidgets("This week - daylight savings change", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisWeek),
      now: TimeManager.get.dateTimeFromValues(2019, 3, 10, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 3, 4, 0, 0, 0),
    );
  });

  testWidgets("This month - first day", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisMonth),
      now: TimeManager.get.dateTimeFromValues(2019, 2, 1, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 2, 1, 0, 0, 0),
    );
  });

  testWidgets("This month - last day", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisMonth),
      now: TimeManager.get.dateTimeFromValues(2019, 3, 31, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 3, 1, 0, 0, 0),
    );

    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisMonth),
      now: TimeManager.get.dateTimeFromValues(2019, 2, 28, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 2, 1, 0, 0, 0),
    );

    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisMonth),
      now: TimeManager.get.dateTimeFromValues(2019, 4, 30, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 4, 1, 0, 0, 0),
    );
  });

  testWidgets("This month - somewhere in the middle", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisMonth),
      now: TimeManager.get.dateTimeFromValues(2019, 5, 17, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 5, 1, 0, 0, 0),
    );
  });

  testWidgets("This month - daylight savings change", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisMonth),
      now: TimeManager.get.dateTimeFromValues(2019, 3, 13, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 3, 1, 0, 0, 0),
    );
  });

  testWidgets("This year - first day", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisYear),
      now: TimeManager.get.dateTimeFromValues(2019, 1, 1, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 1, 1, 0, 0, 0),
    );
  });

  testWidgets("This year - last day", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisYear),
      now: TimeManager.get.dateTimeFromValues(2019, 12, 31, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 1, 1, 0, 0, 0),
    );
  });

  testWidgets("This year - somewhere in the middle", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisYear),
      now: TimeManager.get.dateTimeFromValues(2019, 5, 17, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 1, 1, 0, 0, 0),
    );
  });

  testWidgets("This year - daylight savings change", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.thisYear),
      now: TimeManager.get.dateTimeFromValues(2019, 3, 13, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 1, 1, 0, 0, 0),
    );
  });

  testWidgets("Last week - year overlap", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.lastWeek),
      now: TimeManager.get.dateTimeFromValues(2019, 1, 3, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2018, 12, 24, 0, 0, 0),
      expectedEnd: TimeManager.get.dateTimeFromValues(2018, 12, 31, 0, 0, 0),
    );
  });

  testWidgets("Last week - within the same month", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.lastWeek),
      now: TimeManager.get.dateTimeFromValues(2019, 2, 13, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 2, 4, 0, 0, 0),
      expectedEnd: TimeManager.get.dateTimeFromValues(2019, 2, 11, 0, 0, 0),
    );
  });

  testWidgets("Last week - same day as week start", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.lastWeek),
      now: TimeManager.get.dateTimeFromValues(2019, 2, 4, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 1, 28, 0, 0, 0),
      expectedEnd: TimeManager.get.dateTimeFromValues(2019, 2, 4, 0, 0, 0),
    );
  });

  testWidgets("Last week - daylight savings change", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.lastWeek),
      now: TimeManager.get.dateTimeFromValues(2019, 3, 13, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 3, 3, 23, 0, 0),
      expectedEnd: TimeManager.get.dateTimeFromValues(2019, 3, 11, 0, 0, 0),
    );
  });

  testWidgets("Last month - year overlap", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.lastMonth),
      now: TimeManager.get.dateTimeFromValues(2019, 1, 3, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2018, 12, 1, 0, 0, 0),
      expectedEnd: TimeManager.get.dateTimeFromValues(2019, 1, 1, 0, 0, 0),
    );
  });

  testWidgets("Last month - within same year", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.lastMonth),
      now: TimeManager.get.dateTimeFromValues(2019, 2, 4, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 1, 1, 0, 0, 0),
      expectedEnd: TimeManager.get.dateTimeFromValues(2019, 2, 1, 0, 0, 0),
    );
  });

  testWidgets("Last month - daylight savings change", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.lastMonth),
      now: TimeManager.get.dateTimeFromValues(2019, 3, 13, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 2, 1, 0, 0, 0),
      expectedEnd: TimeManager.get.dateTimeFromValues(2019, 3, 1, 0, 0, 0),
    );
  });

  testWidgets("Last year - normal case", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.lastYear),
      now: TimeManager.get.dateTimeFromValues(2019, 12, 26, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2018, 1, 1, 0, 0, 0),
      expectedEnd: TimeManager.get.dateTimeFromValues(2019, 1, 1, 0, 0, 0),
    );
  });

  testWidgets("Last year - daylight savings change", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.lastYear),
      now: TimeManager.get.dateTimeFromValues(2019, 3, 13, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2018, 1, 1, 0, 0, 0),
      expectedEnd: TimeManager.get.dateTimeFromValues(2019, 1, 1, 0, 0, 0),
    );
  });

  testWidgets("Last 7 days - normal case", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.last7Days),
      now: TimeManager.get.dateTimeFromValues(2019, 2, 20, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 2, 13, 15, 30, 0),
    );
  });

  testWidgets("Last 7 days - daylight savings change", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.last7Days),
      now: TimeManager.get.dateTimeFromValues(2019, 3, 13, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 3, 6, 14, 30, 0),
    );
  });

  testWidgets("Last 14 days - normal case", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.last14Days),
      now: TimeManager.get.dateTimeFromValues(2019, 2, 20, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 2, 6, 15, 30, 0),
    );
  });

  testWidgets("Last 14 days - daylight savings change", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.last14Days),
      now: TimeManager.get.dateTimeFromValues(2019, 3, 13, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 2, 27, 14, 30, 0),
    );
  });

  testWidgets("Last 30 days - normal case", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.last30Days),
      now: TimeManager.get.dateTimeFromValues(2019, 2, 20, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 1, 21, 15, 30, 0),
    );
  });

  testWidgets("Last 30 days - daylight savings change", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.last30Days),
      now: TimeManager.get.dateTimeFromValues(2019, 3, 13, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 2, 11, 14, 30, 0),
    );
  });

  testWidgets("Last 60 days - normal case", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.last60Days),
      now: TimeManager.get.dateTimeFromValues(2019, 2, 20, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(
        2018,
        12,
        22,
        15,
        30,
        0,
      ),
    );
  });

  testWidgets("Last 60 days - daylight savings change", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.last60Days),
      now: TimeManager.get.dateTimeFromValues(2019, 3, 13, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2019, 1, 12, 14, 30, 0),
    );
  });

  testWidgets("Last 12 months - normal case", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.last12Months),
      now: TimeManager.get.dateTimeFromValues(2019, 2, 20, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2018, 2, 20, 15, 30),
    );
  });

  testWidgets("Last 12 months - daylight savings change", (tester) async {
    assertStatsDateRange(
      tester,
      dateRange: DateRange(period: DateRange_Period.last12Months),
      now: TimeManager.get.dateTimeFromValues(2019, 3, 13, 15, 30),
      expectedStart: TimeManager.get.dateTimeFromValues(2018, 3, 13, 15, 30),
    );
  });
}
