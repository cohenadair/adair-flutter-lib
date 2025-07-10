import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:adair_flutter_lib/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';

import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
  });

  test("isLater", () {
    expect(
      isLater(
        const TimeOfDay(hour: 10, minute: 30),
        const TimeOfDay(hour: 8, minute: 30),
      ),
      true,
    );
    expect(
      isLater(
        const TimeOfDay(hour: 10, minute: 30),
        const TimeOfDay(hour: 10, minute: 30),
      ),
      false,
    );
    expect(
      isLater(
        const TimeOfDay(hour: 10, minute: 30),
        const TimeOfDay(hour: 10, minute: 45),
      ),
      false,
    );
    expect(
      isLater(
        const TimeOfDay(hour: 10, minute: 30),
        const TimeOfDay(hour: 10, minute: 15),
      ),
      true,
    );
  });

  group("isInFutureWithMinuteAccuracy", () {
    TZDateTime now() =>
        TimeManager.get.dateTimeFromValues(2015, 5, 15, 12, 30, 45, 10000);

    test("Value should be in the past", () {
      expect(
        isInFutureWithMinuteAccuracy(
          TimeManager.get.dateTimeFromValues(2014, 6, 16, 13, 31, 46, 10001),
          now(),
        ),
        isFalse,
      );
      expect(
        isInFutureWithMinuteAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 4, 16, 13, 31, 46, 10001),
          now(),
        ),
        isFalse,
      );
      expect(
        isInFutureWithMinuteAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 14, 13, 31, 46, 10001),
          now(),
        ),
        isFalse,
      );
      expect(
        isInFutureWithMinuteAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 15, 11, 31, 46, 10001),
          now(),
        ),
        isFalse,
      );
      expect(
        isInFutureWithMinuteAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 15, 12, 29, 46, 10001),
          now(),
        ),
        isFalse,
      );
    });

    test("Value should be in the future", () {
      expect(
        isInFutureWithMinuteAccuracy(
          TimeManager.get.dateTimeFromValues(2016, 4, 14, 11, 29, 44, 9999),
          now(),
        ),
        isTrue,
      );
      expect(
        isInFutureWithMinuteAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 6, 14, 11, 29, 44, 9999),
          now(),
        ),
        isTrue,
      );
      expect(
        isInFutureWithMinuteAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 16, 11, 29, 44, 9999),
          now(),
        ),
        isTrue,
      );
      expect(
        isInFutureWithMinuteAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 15, 13, 29, 44, 9999),
          now(),
        ),
        isTrue,
      );
    });

    test("Values are equal, but isInFuture returns false", () {
      // Equal, since seconds and milliseconds aren't considered.
      expect(
        isInFutureWithMinuteAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 15, 12, 30, 44, 10001),
          now(),
        ),
        isFalse,
      );
      expect(
        isInFutureWithMinuteAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 15, 12, 30, 45, 9999),
          now(),
        ),
        isFalse,
      );
      expect(
        isInFutureWithMinuteAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 15, 12, 30, 44, 9999),
          now(),
        ),
        isFalse,
      );
    });
  });

  group("isInFutureWithDayAccuracy", () {
    TZDateTime now() =>
        TimeManager.get.dateTimeFromValues(2015, 5, 15, 12, 30, 45, 10000);

    test("Value should be in the past", () {
      expect(
        isInFutureWithDayAccuracy(
          TimeManager.get.dateTimeFromValues(2014, 6, 16, 13, 31, 46, 10001),
          now(),
        ),
        isFalse,
      );
      expect(
        isInFutureWithDayAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 4, 16, 13, 31, 46, 10001),
          now(),
        ),
        isFalse,
      );
      expect(
        isInFutureWithDayAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 14, 13, 31, 46, 10001),
          now(),
        ),
        isFalse,
      );
    });

    test("Value should be in the future", () {
      expect(
        isInFutureWithDayAccuracy(
          TimeManager.get.dateTimeFromValues(2016, 4, 14, 11, 29, 44, 9999),
          now(),
        ),
        isTrue,
      );
      expect(
        isInFutureWithDayAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 6, 14, 11, 29, 44, 9999),
          now(),
        ),
        isTrue,
      );
      expect(
        isInFutureWithDayAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 16, 11, 29, 44, 9999),
          now(),
        ),
        isTrue,
      );
    });

    test("Values are equal, but isInFuture returns false", () {
      // Equal, since seconds and milliseconds aren't considered.
      expect(
        isInFutureWithDayAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 15, 11, 31, 46, 10001),
          now(),
        ),
        isFalse,
      );
      expect(
        isInFutureWithDayAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 15, 12, 29, 46, 10001),
          now(),
        ),
        isFalse,
      );
      expect(
        isInFutureWithDayAccuracy(
          TimeManager.get.dateTimeFromValues(2015, 5, 15, 13, 29, 44, 9999),
          now(),
        ),
        isFalse,
      );
    });
  });

  testWidgets("combine", (tester) async {
    expect(combine(null, null), isNull);
    expect(combine(null, const TimeOfDay(hour: 5, minute: 5)), isNotNull);
    expect(combine(TimeManager.get.dateTimeFromValues(2020), null), isNotNull);

    expect(
      combine(
        TimeManager.get.dateTimeFromValues(2020, 10, 26, 15, 30, 20, 1000),
        const TimeOfDay(hour: 16, minute: 45),
      ),
      TimeManager.get.dateTimeFromValues(2020, 10, 26, 16, 45, 20, 1000),
    );

    var actual = combine(null, const TimeOfDay(hour: 16, minute: 45));
    var expected = TimeManager.get.dateTimeFromValues(0, 1, 1, 16, 45);
    expect(actual, expected);
    expect(actual!.locationName, "America/New_York");
  });

  test("dateTimeToDayAccuracy", () {
    expect(
      dateTimeToDayAccuracy(
        TimeManager.get.dateTimeFromValues(2020, 10, 26, 15, 30, 20, 1000),
      ),
      TimeManager.get.dateTimeFromValues(2020, 10, 26, 0, 0, 0, 0),
    );

    initializeTimeZones();

    expect(
      dateTimeToDayAccuracy(
        TimeManager.get.dateTimeFromValues(2020, 10, 26, 15, 30, 20, 1000),
        "America/Chicago",
      ),
      TZDateTime(getLocation("America/Chicago"), 2020, 10, 26, 0, 0, 0, 0),
    );
  });

  test("getStartOfWeek", () {
    expect(
      startOfWeek(TimeManager.get.dateTimeFromValues(2020, 9, 24)),
      TimeManager.get.dateTimeFromValues(2020, 9, 21),
    );
  });

  test("weekOfYear", () {
    expect(weekOfYear(TimeManager.get.dateTimeFromValues(2020, 2, 15)), 7);
  });

  test("dayOfYear", () {
    expect(dayOfYear(TimeManager.get.dateTimeFromValues(2020, 2, 15)), 46);
  });

  testWidgets("formatTimeOfDay", (tester) async {
    expect(
      formatTimeOfDay(
        await buildContext(tester),
        const TimeOfDay(hour: 15, minute: 30),
      ),
      "3:30 PM",
    );
    expect(
      formatTimeOfDay(
        await buildContext(tester, use24Hour: true),
        const TimeOfDay(hour: 15, minute: 30),
      ),
      "15:30",
    );
  });

  testWidgets("formatHourRange", (tester) async {
    // 11-midnight
    expect(
      formatHourRange(await buildContext(tester), 23, 24),
      "11:00 PM to 12:00 AM",
    );

    // Other
    expect(
      formatHourRange(await buildContext(tester), 8, 10),
      "8:00 AM to 10:00 AM",
    );
  });

  testWidgets("timestampToSearchString", (tester) async {
    var dateTime = TZDateTime(getLocation("America/New_York"), 2020, 9, 24);
    when(managers.timeManager.currentDateTime).thenReturn(dateTime);
    when(managers.timeManager.dateTime(any, any)).thenReturn(dateTime);

    expect(
      timestampToSearchString(
        await buildContext(tester),
        dateTime.millisecondsSinceEpoch,
        null,
      ),
      "Today at 12:00 AM September 24, 2020",
    );
  });

  testWidgets("formatDateAsRecent", (tester) async {
    when(
      managers.timeManager.currentDateTime,
    ).thenReturn(TZDateTime(getLocation("America/New_York"), 2020, 9, 24));

    await buildContext(tester); // To use L10n.

    expect(
      formatDateAsRecent(
        TZDateTime(getLocation("America/New_York"), 2020, 9, 24),
      ),
      "Today",
    );
    expect(
      formatDateAsRecent(
        TZDateTime(getLocation("America/New_York"), 2020, 9, 23),
      ),
      "Yesterday",
    );
    expect(
      formatDateAsRecent(
        TZDateTime(getLocation("America/New_York"), 2020, 9, 22),
      ),
      "Tuesday",
    );
    expect(
      formatDateAsRecent(
        TZDateTime(getLocation("America/New_York"), 2020, 9, 22),
        abbreviated: true,
      ),
      "Tue",
    );
    expect(
      formatDateAsRecent(
        TZDateTime(getLocation("America/New_York"), 2020, 8, 22),
      ),
      "Aug 22",
    );
    expect(
      formatDateAsRecent(
        TZDateTime(getLocation("America/New_York"), 2019, 8, 22),
      ),
      "Aug 22, 2019",
    );
  });

  testWidgets("formatDateTime exclude midnight", (tester) async {
    when(
      managers.timeManager.currentDateTime,
    ).thenReturn(TZDateTime(getLocation("America/New_York"), 2020, 9, 24));

    var context = await buildContext(tester);

    expect(
      formatDateTime(
        context,
        TZDateTime(getLocation("America/New_York"), 2020, 8, 22),
        excludeMidnight: false,
      ),
      "Aug 22 at 12:00 AM",
    );
    expect(
      formatDateTime(
        context,
        TZDateTime(getLocation("America/New_York"), 2020, 8, 22),
        excludeMidnight: true,
      ),
      "Aug 22",
    );
  });

  testWidgets("isFrequencyTimerReady timer is null", (tester) async {
    when(managers.timeManager.currentTimestamp).thenReturn(0);

    var invoked = false;
    expect(
      isFrequencyTimerReady(
        timerStartedAt: null,
        setTimer: (_) => invoked = true,
        frequency: 1000,
      ),
      isFalse,
    );

    expect(invoked, isTrue);
    verify(managers.timeManager.currentTimestamp).called(1);
  });

  testWidgets("isFrequencyTimerReady not enough time has passed", (
    tester,
  ) async {
    when(managers.timeManager.currentTimestamp).thenReturn(1500);

    expect(
      isFrequencyTimerReady(
        timerStartedAt: 1000,
        setTimer: (_) {},
        frequency: 1000,
      ),
      isFalse,
    );

    verify(managers.timeManager.currentTimestamp).called(1);
  });

  testWidgets("isFrequencyTimerReady returns true", (tester) async {
    when(managers.timeManager.currentTimestamp).thenReturn(10000);

    expect(
      isFrequencyTimerReady(
        timerStartedAt: 1000,
        setTimer: (_) {},
        frequency: 1000,
      ),
      isTrue,
    );
  });

  test("isSameMonth", () {
    expect(
      isSameYearAndMonth(
        TimeManager.get.dateTimeFromValues(2022, 10, 5),
        TimeManager.get.dateTimeFromValues(2022, 10, 6),
      ),
      isTrue,
    );

    expect(
      isSameYearAndMonth(
        TimeManager.get.dateTimeFromValues(2022, 11, 5),
        TimeManager.get.dateTimeFromValues(2022, 10, 6),
      ),
      isFalse,
    );

    expect(
      isSameYearAndMonth(
        TimeManager.get.dateTimeFromValues(2021, 11, 5),
        TimeManager.get.dateTimeFromValues(2022, 10, 6),
      ),
      isFalse,
    );
  });
}
