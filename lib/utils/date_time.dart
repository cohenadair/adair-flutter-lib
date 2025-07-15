import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';
import 'package:quiver/time.dart';
import 'package:timezone/timezone.dart';

import '../l10n/l10n.dart';
import '../managers/time_manager.dart';
import 'date_format.dart';

bool isSameYear(TZDateTime a, TZDateTime b) {
  return a.year == b.year;
}

bool isSameMonth(TZDateTime a, TZDateTime b) {
  return a.month == b.month;
}

bool isSameYearAndMonth(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month;
}

bool isSameDay(TZDateTime a, TZDateTime b) {
  return a.day == b.day;
}

bool isSameTimeOfDay(TZDateTime a, TZDateTime b) {
  return TimeOfDay.fromDateTime(a) == TimeOfDay.fromDateTime(b);
}

/// Returns `true` if `a` is later in the day than `b`.
bool isLater(TimeOfDay a, TimeOfDay b) {
  return a.hour > b.hour || (a.hour == b.hour && a.minute > b.minute);
}

/// Returns `true` if the given [TZDateTime] comes after `now`, to minute
/// accuracy.
bool isInFutureWithMinuteAccuracy(TZDateTime dateTime, TZDateTime now) {
  var newDateTime = dateTimeToMinuteAccuracy(dateTime);
  var newNow = dateTimeToMinuteAccuracy(now);
  return newDateTime.isAfter(newNow);
}

/// Returns `true` if the given [TZDateTime] comes after `now`, to day
/// accuracy.
bool isInFutureWithDayAccuracy(TZDateTime dateTime, TZDateTime now) {
  var newDateTime = dateTimeToDayAccuracy(dateTime);
  var newNow = dateTimeToDayAccuracy(now);
  return newDateTime.isAfter(newNow);
}

/// Returns true if the given [TZDateTime] objects are equal. Compares
/// only year, month, and day.
bool isSameDate(TZDateTime a, TZDateTime b) {
  return isSameYear(a, b) && isSameMonth(a, b) && isSameDay(a, b);
}

bool isYesterday(TZDateTime today, TZDateTime yesterday) {
  return isSameDate(yesterday, today.subtract(aDay));
}

/// Returns true of the  given TZDateTime objects are within one week of one
/// another.
bool isWithinOneWeek(TZDateTime a, TZDateTime b) {
  return a.difference(b).inMilliseconds.abs() <= aWeek.inMilliseconds;
}

/// Returns a [TZDateTime] object with the given [TZDateTime] and [TimeOfDay]
/// combined.  Accurate to the millisecond.
///
/// Due to the lack of granularity in [TimeOfDay], the seconds and milliseconds
/// value of the result are that of the given [TZDateTime].
TZDateTime? combine(TZDateTime? dateTime, TimeOfDay? timeOfDay) {
  if (dateTime == null && timeOfDay == null) {
    return null;
  }

  return TZDateTime(
    dateTime?.location ?? TimeManager.get.currentLocation.value,
    dateTime?.year ?? 0,
    dateTime?.month ?? 1,
    dateTime?.day ?? 1,
    timeOfDay?.hour ?? 0,
    timeOfDay?.minute ?? 0,
    dateTime?.second ?? 0,
    dateTime?.millisecond ?? 0,
  );
}

/// Returns a new [TZDateTime] object, with time properties more granular than
/// minutes set to 0.
TZDateTime dateTimeToMinuteAccuracy(TZDateTime dateTime) {
  return TZDateTime(
    dateTime.location,
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
  );
}

/// Returns a new [TZDateTime] object, with time properties more granular than
/// day set to 0.
TZDateTime dateTimeToDayAccuracy(TZDateTime dateTime, [String? timeZone]) {
  return TZDateTime(
    isEmpty(timeZone) ? dateTime.location : getLocation(timeZone!),
    dateTime.year,
    dateTime.month,
    dateTime.day,
  );
}

/// Returns a [TZDateTime] representing the start of the week to which `now`
/// belongs.
TZDateTime startOfWeek(TZDateTime now) {
  return dateTimeToDayAccuracy(now).subtract(Duration(days: now.weekday - 1));
}

/// Returns a [TZDateTime] representing the start of the month to which `now`
/// belongs.
TZDateTime startOfMonth(TZDateTime now) {
  return TZDateTime(now.location, now.year, now.month);
}

/// Returns a [TZDateTime] representing the start of the year to which `now`
/// belongs.
TZDateTime startOfYear(TZDateTime now) {
  return TZDateTime(now.location, now.year);
}

/// Calculates week number from a date as per
/// https://en.wikipedia.org/wiki/ISO_week_date#Calculation.
int weekOfYear(TZDateTime date) {
  return ((dayOfYear(date) - date.weekday + 10) / DateTime.daysPerWeek).floor();
}

/// Returns the day of the year for the given [TZDateTime]. For example, 185.
int dayOfYear(TZDateTime date) {
  return int.parse(DateFormat("D").format(date));
}

/// Returns a formatted [String] for a time of day. The format depends on a
/// combination of the current locale and the user's system time format setting.
///
/// Example:
///   21:35, or
///   9:35 PM
String formatTimeOfDay(BuildContext context, TimeOfDay time) {
  return MaterialLocalizations.of(context).formatTimeOfDay(
    time,
    alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
  );
}

/// Returns a formatted hour range for the give [startHour] and [endHour].
///
/// Example:
///   8:00 AM to 9:00 AM, or
///   15:00 to 16:00
String formatHourRange(BuildContext context, int startHour, int endHour) {
  if (endHour == Duration.hoursPerDay) {
    endHour = 0;
  }

  var start = TimeOfDay(hour: startHour, minute: 0);
  var end = TimeOfDay(hour: endHour, minute: 0);

  return L10n.get.lib.dateRangeFormat(
    formatTimeOfDay(context, start),
    formatTimeOfDay(context, end),
  );
}

String formatTimeMillis(BuildContext context, Int64 millis, String? timeZone) {
  return formatTimeOfDay(
    context,
    TimeOfDay.fromDateTime(TimeManager.get.dateTime(millis.toInt(), timeZone)),
  );
}

/// Returns a formatted [TZDateTime] to be displayed to the user. Includes date
/// and time.
///
/// Examples:
///   - Today at 2:35 PM
///   - Yesterday at 2:35 PM
///   - Monday at 2:35 PM
///   - Jan 8 at 2:35 PM
///   - Dec 8, 2018 at 2:35 PM
String formatDateTime(
  BuildContext context,
  TZDateTime dateTime, {
  bool abbreviated = false,
  bool excludeMidnight = false,
}) {
  var recentDate = formatDateAsRecent(dateTime, abbreviated: abbreviated);

  var time = TimeOfDay.fromDateTime(dateTime);
  if (excludeMidnight && time.hour == 0 && time.minute == 0) {
    return recentDate;
  }

  return L10n.get.lib.dateTimeFormat(
    recentDate,
    formatTimeOfDay(context, time),
  );
}

String formatTimestamp(BuildContext context, int timestamp, String? timeZone) {
  return formatDateTime(context, TimeManager.get.dateTime(timestamp, timeZone));
}

/// Returns a [Timestamp] as a searchable [String]. This value should not be
/// shown to users, but to be used for searching through list items that include
/// timestamps.
///
/// The value returned is just a concatenation of different ways of representing
/// a date and time.
String timestampToSearchString(
  BuildContext context,
  int timestamp,
  String? timeZone,
) {
  var dateTime = TimeManager.get.dateTime(timestamp, timeZone);
  return "${formatDateTime(context, dateTime)} "
      "${DateFormats.localized(L10n.get.lib.dateFormatMonthDayYearFull).format(dateTime)}";
}

/// Returns a formatted [TZDateTime] to be displayed to the user. Includes
/// date only.
///
/// Examples:
///   - Today
///   - Yesterday
///   - Monday
///   - Jan. 8
///   - Dec. 8, 2018
String formatDateAsRecent(TZDateTime dateTime, {bool abbreviated = false}) {
  final now = TimeManager.get.currentDateTime;
  var format = "";

  if (isSameDate(dateTime, now)) {
    // Today.
    return L10n.get.lib.today;
  } else if (isYesterday(now, dateTime)) {
    // Yesterday.
    return L10n.get.lib.yesterday;
  } else if (isWithinOneWeek(dateTime, now)) {
    // 2 days ago to 6 days ago.
    format = abbreviated
        ? L10n.get.lib.dateFormatWeekDay
        : L10n.get.lib.dateFormatWeekDayFull;
  } else if (isSameYear(dateTime, now)) {
    // Same year.
    format = L10n.get.lib.dateFormatMonthDay;
  } else {
    // Different year.
    format = L10n.get.lib.dateFormatMonthDayYear;
  }

  return DateFormats.localized(format).format(dateTime);
}

bool isFrequencyTimerReady({
  required int? timerStartedAt,
  required void Function(int?) setTimer,
  required int frequency,
}) {
  // If the timer hasn't started yet, start it now and exit early. This prevents
  // the handler from being called prematurely.
  if (timerStartedAt == null) {
    setTimer(TimeManager.get.currentTimestamp);
    return false;
  }

  // If enough time hasn't passed, exit early.
  if (TimeManager.get.currentTimestamp - timerStartedAt <= frequency) {
    return false;
  }

  return true;
}

extension TZDateTimes on TZDateTime {
  String get locationName => location.name;

  bool get isMidnight => hour == 0 && minute == 0;
}

extension TimeOfDays on TimeOfDay {
  bool get isMidnight => hour == 0 && minute == 0;
}
