import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';

import '../utils/duration.dart';
import '../utils/log.dart';
import '../utils/string.dart';
import '../wrappers/native_time_zone_wrapper.dart';

class TimeManager {
  static var _instance = TimeManager._();

  static TimeManager get get => _instance;

  @visibleForTesting
  static void set(TimeManager manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = TimeManager._();

  TimeManager._();

  final _log = const Log("TimeManager");

  @visibleForTesting
  TimeManager();

  TZDateTime get currentDateTime => TZDateTime.now(currentLocation.value);

  TimeZoneLocation get currentLocation => _currentLocation;

  TimeOfDay get currentTime => TimeOfDay.now();

  int get currentTimestamp => currentDateTime.millisecondsSinceEpoch;

  String get currentTimeZone => currentLocation.name;

  List<TimeZoneLocation> _availableLocations = [];
  late TimeZoneLocation _currentLocation;

  Future<void> init() async {
    initializeTimeZones();

    // Filter out all time zones that aren't available on the current device.
    var nativeTimeZones =
        await NativeTimeZoneWrapper.get.getAvailableTimeZones();
    _availableLocations = timeZoneDatabase.locations.values
        .where((loc) => nativeTimeZones.contains(loc.name))
        .map((loc) => TimeZoneLocation(loc))
        .toList();
    _availableLocations.sort((lhs, rhs) {
      var result = lhs.currentTimeZone.offset.compareTo(
        rhs.currentTimeZone.offset,
      );
      if (result == 0) {
        return lhs.name.compareTo(rhs.name);
      }
      return result;
    });

    _currentLocation = TimeZoneLocation.fromName(
      await NativeTimeZoneWrapper.get.getLocalTimeZone(),
    );

    _log.d("Available time zone locations: ${_availableLocations.length}");
  }

  List<TimeZoneLocation> filteredLocations(
    String? query, {
    TimeZoneLocation? exclude,
  }) {
    return _availableLocations
        .where((loc) => loc != exclude && loc.matchesFilter(query))
        .toList();
  }

  /// Returns a [TZDateTime] from the given timestamp and time zone. If
  /// [timeZone] is empty, the current time zone is used.
  TZDateTime dateTime(int timestamp, [String? timeZone]) {
    return TZDateTime.fromMillisecondsSinceEpoch(
      getLocation(timeZone ?? currentTimeZone),
      timestamp,
    );
  }

  /// A seconds accuracy wrapper for [dateTime].
  TZDateTime dateTimeFromSeconds(int timestampSeconds, [String? timeZone]) {
    return dateTime(
      timestampSeconds * Duration.millisecondsPerSecond,
      timeZone,
    );
  }

  /// A wrapper for the [TZDateTime] default constructor that uses the current
  /// [Location].
  TZDateTime dateTimeFromValues(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
    String? timeZone,
  ]) {
    return TZDateTime(
      getLocation(timeZone ?? currentTimeZone),
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
    );
  }

  TZDateTime dateTimeToTz(DateTime dateTime) {
    return TZDateTime.from(dateTime, currentLocation.value);
  }

  /// Returns the current [TZDateTime] at the given time zone, or the
  /// current time zone if [timeZone] is invalid.
  TZDateTime now([String? timeZone]) {
    return isEmpty(timeZone)
        ? currentDateTime
        : TZDateTime.now(getLocation(timeZone!));
  }
}

@immutable
class TimeZoneLocation {
  final Location _value;

  const TimeZoneLocation(this._value);

  TimeZoneLocation.fromName(String name) : this(getLocation(name));

  TimeZone get currentTimeZone => _value.currentTimeZone;

  String get name => _value.name;

  String get displayName => name.replaceAll("_", " ");

  String get displayNameUtc => "$displayName ($displayUtc)";

  String get displayUtc {
    var currentOffset = currentTimeZone.offset.abs();
    var offset = "UTC";
    if (currentTimeZone.offset != 0) {
      offset += currentTimeZone.offset < 0 ? "-" : "+";
      offset += DisplayDuration(
        Duration(milliseconds: currentOffset),
      ).formatHoursMinutes();
    }
    return offset;
  }

  Location get value => _value;

  bool matchesFilter(String? filter) {
    if (isEmpty(filter)) {
      return true;
    }

    var searchableText =
        "$displayName ${_value.zones.map((e) => e.abbreviation).join(" ")}";
    return containsTrimmedLowerCase(searchableText, filter!);
  }

  @override
  bool operator ==(Object other) =>
      other is TimeZoneLocation && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
