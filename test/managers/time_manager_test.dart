import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();

    when(managers.nativeTimeZoneWrapper.getAvailableTimeZones()).thenAnswer((
      _,
    ) {
      return Future.value([
        "America/New_York",
        "America/Chicago",
        "Europe/Isle_of_Man",
      ]);
    });
    when(
      managers.nativeTimeZoneWrapper.getLocalTimeZone(),
    ).thenAnswer((realInvocation) => Future.value("America/New_York"));

    TimeManager.reset();
    await TimeManager.get.init();
  });

  test("init reconciles native and lib time zones", () async {
    when(managers.nativeTimeZoneWrapper.getAvailableTimeZones()).thenAnswer((
      _,
    ) {
      return Future.value([
        "Europe/Isle_of_Man",
        "America/Menominee",
        "America/Matamoros",
      ]);
    });

    await TimeManager.get.init();

    // Verify count, and sort by offset, then alphabetically.
    var locations = TimeManager.get.filteredLocations(null);
    expect(locations.length, 3);
    expect(locations[0].name, "America/Matamoros");
    expect(locations[1].name, "America/Menominee");
    expect(locations[2].name, "Europe/Isle_of_Man");
  });

  test("filteredLocations excludes location", () async {
    var locations = TimeManager.get.filteredLocations(
      null,
      exclude: TimeZoneLocation.fromName("America/New_York"),
    );
    expect(locations.length, 2);
    expect(locations[0].name, "America/Chicago");
    expect(locations[1].name, "Europe/Isle_of_Man");
  });

  test("dateTime defaults to current time zone", () async {
    expect(TimeManager.get.dateTime(5000).location.name, "America/New_York");
  });

  test("dateTime uses input time zone", () async {
    expect(
      TimeManager.get.dateTime(5000, "America/Chicago").location.name,
      "America/Chicago",
    );
  });

  test("now defaults to current time zone", () async {
    expect(TimeManager.get.now().location.name, "America/New_York");
  });

  test("now uses input time zone", () async {
    expect(
      TimeManager.get.now("America/Chicago").location.name,
      "America/Chicago",
    );
  });

  test("TimeZoneLocation displayName replaces _", () {
    expect(
      TimeZoneLocation.fromName("America/New_York").displayName,
      "America/New York",
    );
  });

  test("TimeZoneLocation displayNameUtc includes offset", () {
    expect(
      TimeZoneLocation.fromName("America/New_York").displayNameUtc,
      TimeZoneLocation.fromName("America/New_York").currentTimeZone.isDst
          ? "America/New York (UTC-04:00)"
          : "America/New York (UTC-05:00)",
    );
  });

  test("TimeZoneLocation displayUtc with 0 offset", () {
    expect(
      TimeZoneLocation.fromName("Atlantic/Azores").displayNameUtc,
      TimeZoneLocation.fromName("Atlantic/Azores").currentTimeZone.isDst
          ? "Atlantic/Azores (UTC)"
          : "Atlantic/Azores (UTC-01:00)",
    );
  });

  test("TimeZoneLocation displayUtc with negative offset", () {
    expect(
      TimeZoneLocation.fromName("America/New_York").displayNameUtc,
      TimeZoneLocation.fromName("America/New_York").currentTimeZone.isDst
          ? "America/New York (UTC-04:00)"
          : "America/New York (UTC-05:00)",
    );
  });

  test("TimeZoneLocation displayUtc with positive offset", () {
    expect(
      TimeZoneLocation.fromName("Africa/Tunis").displayNameUtc,
      "Africa/Tunis (UTC+01:00)",
    );
  });

  test("TimeZoneLocation matchesFilter empty filter returns true", () {
    expect(TimeZoneLocation.fromName("Africa/Tunis").matchesFilter(""), isTrue);
    expect(
      TimeZoneLocation.fromName("Africa/Tunis").matchesFilter(null),
      isTrue,
    );
  });

  test("TimeZoneLocation matchesFilter using display name", () {
    expect(
      TimeZoneLocation.fromName("Africa/Tunis").matchesFilter("Tun"),
      isTrue,
    );
  });

  test("TimeZoneLocation matchesFilter using abbreviation", () {
    expect(
      TimeZoneLocation.fromName("America/New_York").matchesFilter("EST"),
      isTrue,
    );
  });

  test("TimeZoneLocation ==", () {
    expect(
      TimeZoneLocation.fromName("America/New_York") ==
          TimeZoneLocation.fromName("America/New_York"),
      isTrue,
    );
  });

  test(
    "dateTimeFromSeconds converts seconds to a TZDateTime in the current time zone",
    () {
      final result = TimeManager.get.dateTimeFromSeconds(5);
      expect(result.location.name, "America/New_York");
      expect(result.millisecondsSinceEpoch, 5 * Duration.millisecondsPerSecond);
    },
  );

  test("dateTimeFromSeconds uses the specified time zone", () {
    final result = TimeManager.get.dateTimeFromSeconds(5, "America/Chicago");
    expect(result.location.name, "America/Chicago");
  });

  test(
    "dateTimeFromValues builds a TZDateTime using the current time zone when timeZone is null",
    () {
      final result = TimeManager.get.dateTimeFromValues(2024, 3, 15);
      expect(result.location.name, "America/New_York");
      expect(result.year, 2024);
      expect(result.month, 3);
      expect(result.day, 15);
    },
  );

  test("dateTimeFromValues uses the specified time zone", () {
    final result = TimeManager.get.dateTimeFromValues(
      2024,
      1,
      1,
      0,
      0,
      0,
      0,
      0,
      "America/Chicago",
    );
    expect(result.location.name, "America/Chicago");
  });

  test(
    "dateTimeToTz converts a DateTime to TZDateTime preserving the instant",
    () {
      final now = DateTime.now();
      final result = TimeManager.get.dateTimeToTz(now);
      expect(result.millisecondsSinceEpoch, now.millisecondsSinceEpoch);
      expect(result.location.name, "America/New_York");
    },
  );
}
