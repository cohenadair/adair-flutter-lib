import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

import '../l10n/l10n.dart';
import '../managers/time_manager.dart';
import '../model/gen/adair_flutter_lib.pb.dart';
import 'date_time.dart';

extension DateRanges on DateRange {
  int get startMs => startDate.millisecondsSinceEpoch;

  int get endMs => endDate.millisecondsSinceEpoch;

  int get durationMs => endMs - startMs;

  /// The number of days spanned by the [DateRange]. This is calculated by
  /// taking the total [Duration] of the [DateRange] and dividing it by
  /// [Duration.millisecondsPerDay].
  num get days => durationMs / Duration.millisecondsPerDay;

  /// The number of weeks spanned by the [DateRange]. This is calculated by
  /// taking the total [Duration] of the [DateRange] and dividing it by
  /// the number of milliseconds in a week. A week length is defined by
  /// [DateTime.daysPerWeek].
  num get weeks =>
      durationMs / (Duration.millisecondsPerDay * DateTime.daysPerWeek);

  /// The number of months spanned by the [DateRange]. This is calculated by
  /// taking the total [Duration] of the [DateRange] and dividing it by
  /// the number of milliseconds in a month. A month length is defined as 30
  /// days.
  num get months =>
      durationMs / (Duration.millisecondsPerDay * DateTimes.daysPerMonth);

  TZDateTime get startDate {
    if (hasStartTimestamp()) {
      return TimeManager.get.dateTime(startTimestamp.toInt(), timeZone);
    }

    var now = TimeManager.get.now(timeZone);

    switch (period) {
      case DateRange_Period.allDates:
        return TimeManager.get.dateTime(0, timeZone);
      case DateRange_Period.today:
        return dateTimeToDayAccuracy(now);
      case DateRange_Period.yesterday:
        return dateTimeToDayAccuracy(now).subtract(const Duration(days: 1));
      case DateRange_Period.thisWeek:
        return startOfWeek(now);
      case DateRange_Period.thisMonth:
      case DateRange_Period.custom: // Default custom to this month.
        return startOfMonth(now);
      case DateRange_Period.thisYear:
        return startOfYear(now);
      case DateRange_Period.lastWeek:
        return startOfWeek(now)
            .subtract(const Duration(days: DateTime.daysPerWeek));
      case DateRange_Period.lastMonth:
        var year = now.year;
        var month = now.month - 1;
        if (month < DateTime.january) {
          month = DateTime.december;
          year -= 1;
        }
        return TZDateTime(now.location, year, month);
      case DateRange_Period.lastYear:
        return TZDateTime(now.location, now.year - 1);
      case DateRange_Period.last7Days:
        return now.subtract(const Duration(days: 7));
      case DateRange_Period.last14Days:
        return now.subtract(const Duration(days: 14));
      case DateRange_Period.last30Days:
        return now.subtract(const Duration(days: 30));
      case DateRange_Period.last60Days:
        return now.subtract(const Duration(days: 60));
      case DateRange_Period.last12Months:
      default:
        return now.subtract(const Duration(days: 365));
    }
  }

  TZDateTime get endDate {
    if (hasEndTimestamp()) {
      return TimeManager.get.dateTime(endTimestamp.toInt(), timeZone);
    }

    var now = TimeManager.get.now(timeZone);

    switch (period) {
      case DateRange_Period.allDates:
      case DateRange_Period.today:
      case DateRange_Period.thisWeek:
      case DateRange_Period.thisMonth:
      case DateRange_Period.custom: // Default custom to this month.
      case DateRange_Period.thisYear:
      case DateRange_Period.last7Days:
      case DateRange_Period.last14Days:
      case DateRange_Period.last30Days:
      case DateRange_Period.last60Days:
      case DateRange_Period.last12Months:
        return now;
      case DateRange_Period.yesterday:
        return dateTimeToDayAccuracy(now);
      case DateRange_Period.lastWeek:
        return startOfWeek(now);
      case DateRange_Period.lastMonth:
        return startOfMonth(now);
      case DateRange_Period.lastYear:
        return startOfYear(now);
    }
    throw ArgumentError("Invalid input: $period");
  }

  String get displayName {
    if (hasStartTimestamp() && hasEndTimestamp()) {
      var formatter = DateFormat(
          L10n.get.lib.dateFormatMonthDayYear, L10n.get.lib.localeName);
      return L10n.get.lib.dateRangeFormat(
        formatter.format(startDate),
        formatter.format(endDate),
      );
    }

    switch (period) {
      case DateRange_Period.allDates:
        return L10n.get.lib.durationAllDates;
      case DateRange_Period.today:
        return L10n.get.lib.durationToday;
      case DateRange_Period.yesterday:
        return L10n.get.lib.durationYesterday;
      case DateRange_Period.thisWeek:
        return L10n.get.lib.durationThisWeek;
      case DateRange_Period.thisMonth:
        return L10n.get.lib.durationThisMonth;
      case DateRange_Period.thisYear:
        return L10n.get.lib.durationThisYear;
      case DateRange_Period.last7Days:
        return L10n.get.lib.durationLast7Days;
      case DateRange_Period.last14Days:
        return L10n.get.lib.durationLast14Days;
      case DateRange_Period.last30Days:
        return L10n.get.lib.durationLast30Days;
      case DateRange_Period.last60Days:
        return L10n.get.lib.durationLast60Days;
      case DateRange_Period.last12Months:
        return L10n.get.lib.durationLast12Months;
      case DateRange_Period.lastWeek:
        return L10n.get.lib.durationLastWeek;
      case DateRange_Period.lastMonth:
        return L10n.get.lib.durationLastMonth;
      case DateRange_Period.lastYear:
        return L10n.get.lib.durationLastYear;
      case DateRange_Period.custom:
        return L10n.get.lib.durationCustom;
    }
    throw ArgumentError("Invalid input: $period");
  }

  bool contains(int timestamp) {
    var utcDateRange = deepCopy()..timeZone = "UTC";
    return timestamp >= utcDateRange.startMs && timestamp <= utcDateRange.endMs;
  }
}
