import 'dart:async';

import 'package:adair_flutter_lib/wrappers/local_notifications_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../pages/notification_permission_page.dart';
import '../utils/page.dart';
import '../wrappers/permission_handler_wrapper.dart';
import 'manager.dart';

abstract class NotificationManagerBase implements Manager {
  // Called when a user taps a notification.
  VoidCallback? onDidReceiveNotificationResponse;
  late final FlutterLocalNotificationsPlugin _flutterNotifications;

  @override
  @protected
  Future<void> init() async {
    _flutterNotifications = LocalNotificationsWrapper.get.newInstance();
    await _flutterNotifications.initialize(
      InitializationSettings(
        iOS: DarwinInitializationSettings(
          // Permission is requested when needed.
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          requestCriticalPermission: false,
          requestProvisionalPermission: false,
          notificationCategories: iosCategories,
        ),
        android: AndroidInitializationSettings("ic_notification"),
      ),
      onDidReceiveNotificationResponse: _onReceiveNotificationResponse,
    );
  }

  @protected
  List<DarwinNotificationCategory> get iosCategories => const [];

  void _onReceiveNotificationResponse(NotificationResponse details) {
    onDidReceiveNotificationResponse?.call();
  }

  /// Returns true if notification permission has been granted; false otherwise.
  ///
  /// When [showPermissionPage] is true (default), displays
  /// [NotificationPermissionPage] to explain the request before prompting —
  /// recommended for local notifications that benefit from user context.
  ///
  /// When [showPermissionPage] is false, calls permission is requested directly
  /// directly without an explanation page.
  @protected
  Future<bool> requestPermissionIfNeeded({
    BuildContext? context,
    String userDescription = "",
    bool showPermissionPage = true,
  }) async {
    if (!(await PermissionHandlerWrapper.get.isNotificationDenied)) {
      return PermissionHandlerWrapper.get.isNotificationGranted;
    }

    if (!showPermissionPage) {
      return PermissionHandlerWrapper.get.requestNotification();
    }

    if (context == null || !context.mounted) {
      return false;
    }

    return (await present<bool>(
      context,
      NotificationPermissionPage(userDescription),
    ))!;
  }

  /// Shows a local notification. Wrapper for
  /// [FlutterLocalNotificationsPlugin.show].
  Future<void> show({
    required int id,
    String? title,
    String? body,
    NotificationDetails? details,
    String? payload,
  }) {
    return _flutterNotifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> cancel({required int id}) {
    return _flutterNotifications.cancel(id);
  }
}
