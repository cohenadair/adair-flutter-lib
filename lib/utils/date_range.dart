import 'package:adair_flutter_lib/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

import '../managers/time_manager.dart';
import '../src/strings.dart';
import 'date_time.dart';
import 'duration.dart';

typedef DateRangeCallback = DateRange Function(TZDateTime now);

class DateRange {
  final int _daysInMonth = 30;

  final TZDateTime startDate;
  final TZDateTime endDate;

  DateRange({required this.startDate, required this.endDate})
      : assert(
          startDate.isAtSameMomentAs(endDate) || startDate.isBefore(endDate),
        );

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
  num get months => durationMs / (Duration.millisecondsPerDay * _daysInMonth);

  /// Returns a formatted [DateRange] to be displayed to the user.
  ///
  /// Example:
  ///   Dec. 8, 2018 - Dec. 29, 2018
  String format() {
    return "${DateFormat(monthDayYearFormat).format(startDate)} - ${DateFormat(monthDayYearFormat).format(endDate)}";
  }
}

/// A pre-defined set of date ranges meant for user section. Includes ranges
/// such as "This week", "This month", "Last year", etc.
@immutable
class DisplayDateRange {
  static final allDates = DisplayDateRange._(
    id: "allDates",
    onValue: (now) =>
        DateRange(startDate: TimeManager.get.dateTime(0), endDate: now),
    onTitle: (context) => Strings.of(context).durationAllDates,
  );

  static final today = DisplayDateRange._(
    id: "today",
    onValue: (now) =>
        DateRange(startDate: dateTimeToDayAccuracy(now), endDate: now),
    onTitle: (context) => Strings.of(context).durationToday,
  );

  static final yesterday = DisplayDateRange._(
    id: "yesterday",
    onValue: (now) => DateRange(
      startDate: dateTimeToDayAccuracy(
        now,
      ).subtract(const Duration(days: 1)),
      endDate: dateTimeToDayAccuracy(now),
    ),
    onTitle: (context) => Strings.of(context).durationYesterday,
  );

  static final thisWeek = DisplayDateRange._(
    id: "thisWeek",
    onValue: (now) => DateRange(startDate: startOfWeek(now), endDate: now),
    onTitle: (context) => Strings.of(context).durationThisWeek,
  );

  static final thisMonth = DisplayDateRange._(
    id: "thisMonth",
    onValue: (now) => DateRange(startDate: startOfMonth(now), endDate: now),
    onTitle: (context) => Strings.of(context).durationThisMonth,
  );

  static final thisYear = DisplayDateRange._(
    id: "thisYear",
    onValue: (now) => DateRange(startDate: startOfYear(now), endDate: now),
    onTitle: (context) => Strings.of(context).durationThisYear,
  );

  static final lastWeek = DisplayDateRange._(
    id: "lastWeek",
    onValue: (now) {
      var endOfLastWeek = startOfWeek(now);
      var startOfLastWeek = endOfLastWeek.subtract(
        const Duration(days: DateTime.daysPerWeek),
      );
      return DateRange(startDate: startOfLastWeek, endDate: endOfLastWeek);
    },
    onTitle: (context) => Strings.of(context).durationLastWeek,
  );

  static final lastMonth = DisplayDateRange._(
    id: "lastMonth",
    onValue: (now) {
      var endOfLastMonth = startOfMonth(now);
      var year = now.year;
      var month = now.month - 1;
      if (month < DateTime.january) {
        month = DateTime.december;
        year -= 1;
      }
      return DateRange(
        startDate: TimeManager.get.dateTimeToTz(DateTime(year, month)),
        endDate: endOfLastMonth,
      );
    },
    onTitle: (context) => Strings.of(context).durationLastMonth,
  );

  static final lastYear = DisplayDateRange._(
    id: "lastYear",
    onValue: (now) => DateRange(
      startDate: TimeManager.get.dateTimeToTz(DateTime(now.year - 1)),
      endDate: startOfYear(now),
    ),
    onTitle: (context) => Strings.of(context).durationLastYear,
  );

  static final last7Days = DisplayDateRange._(
    id: "last7Days",
    onValue: (now) => DateRange(
      startDate: now.subtract(const Duration(days: 7)),
      endDate: now,
    ),
    onTitle: (context) => Strings.of(context).durationLast7Days,
  );

  static final last14Days = DisplayDateRange._(
    id: "last14Days",
    onValue: (now) => DateRange(
      startDate: now.subtract(const Duration(days: 14)),
      endDate: now,
    ),
    onTitle: (context) => Strings.of(context).durationLast14Days,
  );

  static final last30Days = DisplayDateRange._(
    id: "last30Days",
    onValue: (now) => DateRange(
      startDate: now.subtract(const Duration(days: 30)),
      endDate: now,
    ),
    onTitle: (context) => Strings.of(context).durationLast30Days,
  );

  static final last60Days = DisplayDateRange._(
    id: "last60Days",
    onValue: (now) => DateRange(
      startDate: now.subtract(const Duration(days: 60)),
      endDate: now,
    ),
    onTitle: (context) => Strings.of(context).durationLast60Days,
  );

  static final last12Months = DisplayDateRange._(
    id: "last12Months",
    onValue: (now) => DateRange(
      startDate: now.subtract(const Duration(days: 365)),
      endDate: now,
    ),
    onTitle: (context) => Strings.of(context).durationLast12Months,
  );

  static final custom = DisplayDateRange._(
    id: "custom",
    onValue: (now) => DisplayDateRange.thisMonth.onValue(now),
    onTitle: (context) => Strings.of(context).durationCustom,
  );

  static final all = [
    allDates,
    today,
    yesterday,
    thisWeek,
    thisMonth,
    thisYear,
    lastWeek,
    lastMonth,
    lastYear,
    last7Days,
    last14Days,
    last30Days,
    last60Days,
    last12Months,
    custom,
  ];

  /// Returns the [DisplayDateRange] for the given ID, or `null` if none exists.
  static DisplayDateRange? of(String id) {
    try {
      return all.firstWhere((range) => range.id == id);
    } on StateError {
      return null;
    }
  }

  final String id;
  final DateRangeCallback onValue;
  final StringCallback onTitle;

  const DisplayDateRange._({
    required this.id,
    required this.onValue,
    required this.onTitle,
  });

  /// Used to create a [DisplayDateRange] with custom start and end dates, but
  /// with the same ID as [DisplayDateRange.custom].
  DisplayDateRange.newCustom({
    required DateRangeCallback onValue,
    required StringCallback onTitle,
  }) : this._(id: custom.id, onValue: onValue, onTitle: onTitle);

  DisplayDateRange.dateRange(DateRange dateRange)
      : this._(
          id: custom.id,
          onValue: (_) => dateRange,
          onTitle: (_) => dateRange.format(),
        );

  DateRange get value => onValue(TimeManager.get.now());

  /// Returns a formatted [Duration] with an appended label for the receiver.
  /// For [custom] and [allDates], no label is added.
  ///
  /// Examples:
  ///   - 0d 12h 45m 0s last week
  ///   - 0d 0h 45m 0s today
  String formatDuration({
    required BuildContext context,
    Duration duration = const Duration(),
    DurationUnit? largestDurationUnit,
  }) {
    String formattedDuration = formatDurations(
      context: context,
      durations: [duration],
      largestDurationUnit: largestDurationUnit,
    );

    if (this == allDates || this == custom) {
      return formattedDuration;
    }

    return "$formattedDuration ${onTitle(context)}";
  }

  @override
  bool operator ==(other) {
    return other is DisplayDateRange && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
