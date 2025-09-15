import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsWrapper {
  static var _instance = LocalNotificationsWrapper._();

  static LocalNotificationsWrapper get get => _instance;

  @visibleForTesting
  static void set(LocalNotificationsWrapper manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = LocalNotificationsWrapper._();

  LocalNotificationsWrapper._();

  FlutterLocalNotificationsPlugin newInstance() =>
      FlutterLocalNotificationsPlugin();
}
