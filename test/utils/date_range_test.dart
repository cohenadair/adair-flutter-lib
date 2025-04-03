import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:adair_flutter_lib/utils/date_range.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils/stubbed_managers.dart';

void main() {
  setUp(() async {
    await StubbedManagers.create(); // Sets up TimeManager.
  });

  test("Days calculated correctly", () {
    DateRange range = DateRange(
      startDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
      endDate: TimeManager.get.dateTimeFromValues(2019, 2, 1),
    );

    expect(range.days, equals(31));

    range = DateRange(
      startDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
      endDate: TimeManager.get.dateTimeFromValues(2019, 1, 10),
    );

    expect(range.days, equals(9));

    range = DateRange(
      startDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
      endDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
    );

    expect(range.days, equals(0));

    range = DateRange(
      startDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
      endDate: TimeManager.get.dateTimeFromValues(2019, 1, 1, 15, 30),
    );

    expect(range.days, equals(0.6458333333333334));
  });

  test("Weeks calculated correctly", () {
    DateRange range = DateRange(
      startDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
      endDate: TimeManager.get.dateTimeFromValues(2019, 2, 1),
    );

    expect(range.weeks, equals(4.428571428571429));

    range = DateRange(
      startDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
      endDate: TimeManager.get.dateTimeFromValues(2019, 3, 10),
    );

    expect(range.weeks, equals(9.714285714285714));

    range = DateRange(
      startDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
      endDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
    );

    expect(range.weeks, equals(0));

    range = DateRange(
      startDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
      endDate: TimeManager.get.dateTimeFromValues(2019, 1, 4),
    );

    expect(range.weeks, equals(0.42857142857142855));
  });

  test("Months calculated correctly", () {
    DateRange range = DateRange(
      startDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
      endDate: TimeManager.get.dateTimeFromValues(2019, 2, 1),
    );

    expect(range.months, equals(1.0333333333333334));

    range = DateRange(
      startDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
      endDate: TimeManager.get.dateTimeFromValues(2019, 3, 10),
    );

    expect(range.months, equals(2.2666666666666666));

    range = DateRange(
      startDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
      endDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
    );

    expect(range.months, equals(0));

    range = DateRange(
      startDate: TimeManager.get.dateTimeFromValues(2019, 1, 1),
      endDate: TimeManager.get.dateTimeFromValues(2019, 1, 20),
    );

    expect(range.months, equals(0.6333333333333333));
  });
}
