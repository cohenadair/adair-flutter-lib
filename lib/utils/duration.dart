import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

/// Units of duration, ordered smallest to largest.
enum DurationUnit { seconds, minutes, hours, days, years }

/// A representation of a [Duration] object meant to be shown to the user. Units
/// are split by largest possible. For example, the hours property is the
/// number of hours in the duration, minus the number of days.
class DisplayDuration {
  final Duration _duration;
  final bool _includesYears;
  final bool _includesDays;
  final bool _includesHours;
  final bool _includesMinutes;

  DisplayDuration(
    this._duration, {
    bool includesYears = true,
    bool includesDays = true,
    bool includesHours = true,
    bool includesMinutes = true,
  }) : _includesYears = includesYears,
       _includesDays = includesDays,
       _includesHours = includesHours,
       _includesMinutes = includesMinutes;

  int get years => _duration.inYears;

  int get days {
    if (_includesYears) {
      return _duration.inDays.remainder(Durations.daysPerYear);
    } else {
      return _duration.inDays;
    }
  }

  int get hours {
    if (_includesDays) {
      return _duration.inHours.remainder(Duration.hoursPerDay);
    } else {
      return _duration.inHours;
    }
  }

  int get minutes {
    if (_includesHours) {
      return _duration.inMinutes.remainder(Duration.minutesPerHour);
    } else {
      return _duration.inMinutes;
    }
  }

  int get seconds {
    if (_includesMinutes) {
      return _duration.inSeconds.remainder(Duration.secondsPerMinute);
    } else {
      return _duration.inSeconds;
    }
  }

  /// Formats the hours and minutes of the [DisplayDuration]. For example,
  /// 05:30.
  String formatHoursMinutes() =>
      "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}";
}

extension Durations on Duration {
  static const monthsPerYear = 12;
  static const daysPerMonth = 30;
  static const daysPerYear = 365;
  static const microsecondsPerYear =
      Duration.microsecondsPerDay * Durations.daysPerYear;

  /// The number of years spanned by this duration.
  int get inYears => inMicroseconds ~/ microsecondsPerYear;
}

/// Returns formatted text to display the total duration of list of [Duration]
/// objects, in the format Dd Hh Mm Ss.
///
/// Example:
///   - 0d 5h 30m 0s
String formatDurations({
  required BuildContext context,
  required List<Duration> durations,
  bool includesYears = true,
  bool includesDays = true,
  bool includesHours = true,
  bool includesMinutes = true,
  bool includesSeconds = true,

  /// If `true`, values equal to 0 will not be included.
  bool condensed = false,

  /// When set, only the largest value quantities will be shown. Null (default)
  /// will show all quantities.
  ///
  /// Examples:
  ///   - Value of 2 will show 1d 12h
  ///   - Value of 1 will show 12h
  ///   - Value of null will show 1d 12h 30m 45s
  int? numberOfQuantities,

  /// The largest [DurationUnit] to use. For example, if equal to
  /// [DurationUnit.hours], 2 days and 3 hours will be formatted as `51h`
  /// rather than `2d 3h`. The same effect can be done by setting `includesDays`
  /// to `false`.
  ///
  /// This is primarily meant for use with a user-preference where the
  /// [DurationUnit] is read from [SharedPreferences].
  DurationUnit? largestDurationUnit,
}) {
  largestDurationUnit ??= DurationUnit.years;
  int totalMillis = 0;

  for (var duration in durations) {
    totalMillis += duration.inMilliseconds;
  }
  includesYears = includesYears && largestDurationUnit == DurationUnit.years;
  includesDays =
      includesDays && largestDurationUnit.index >= DurationUnit.days.index;
  includesHours =
      includesHours && largestDurationUnit.index >= DurationUnit.hours.index;

  DisplayDuration duration = DisplayDuration(
    Duration(milliseconds: totalMillis),
    includesYears: includesYears,
    includesDays: includesDays,
    includesHours: includesHours,
    includesMinutes: includesMinutes,
  );

  var result = "";

  maybeAddSpace() {
    if (result.isNotEmpty) {
      result += " ";
    }
  }

  var numberIncluded = 0;

  bool shouldAdd(bool include, int value) {
    return include &&
        (!condensed || value > 0) &&
        (numberOfQuantities == null || numberIncluded < numberOfQuantities);
  }

  if (shouldAdd(includesYears, duration.years)) {
    result += L10n.get.lib.yearsFormat(duration.years);
    numberIncluded++;
  }

  if (shouldAdd(includesDays, duration.days)) {
    maybeAddSpace();
    result += L10n.get.lib.daysFormat(duration.days);
    numberIncluded++;
  }

  if (shouldAdd(includesHours, duration.hours)) {
    maybeAddSpace();
    result += L10n.get.lib.hoursFormat(duration.hours);
    numberIncluded++;
  }

  if (shouldAdd(includesMinutes, duration.minutes)) {
    maybeAddSpace();
    result += L10n.get.lib.minutesFormat(duration.minutes);
    numberIncluded++;
  }

  if (shouldAdd(includesSeconds, duration.seconds)) {
    maybeAddSpace();
    result += L10n.get.lib.secondsFormat(duration.seconds);
  }

  // If there is no result and not everything is excluded, default to 0m.
  if (result.isEmpty &&
      (includesSeconds || includesMinutes || includesHours || includesDays)) {
    result += L10n.get.lib.minutesFormat(0);
  }

  // Remove all '-', except the first.
  if (result.startsWith("-")) {
    result = "-${result.substring(1).replaceAll("-", "")}";
  }

  return result;
}

Duration averageDuration(int millis, num divisor) {
  return divisor <= 0
      ? const Duration()
      : Duration(milliseconds: (millis / divisor).round());
}
