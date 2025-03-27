import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class NativeTimeZoneWrapper {
  static var _instance = NativeTimeZoneWrapper._();

  static NativeTimeZoneWrapper get get => _instance;

  @visibleForTesting
  static void set(NativeTimeZoneWrapper manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = NativeTimeZoneWrapper._();

  NativeTimeZoneWrapper._();

  Future<List<String>> getAvailableTimeZones() =>
      FlutterTimezone.getAvailableTimezones();

  Future<String> getLocalTimeZone() => FlutterTimezone.getLocalTimezone();
}
