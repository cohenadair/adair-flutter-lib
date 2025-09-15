import 'dart:async';

import 'package:adair_flutter_lib/wrappers/local_notifications_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../pages/notification_permission_page.dart';
import '../utils/page.dart';
import '../wrappers/permission_handler_wrapper.dart';

abstract class NotificationManagerBase {
  // Called when a user taps a notification.
  VoidCallback? onDidReceiveNotificationResponse;
  late final FlutterLocalNotificationsPlugin _flutterNotifications;

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

  /// If needed, [NotificationPermissionPage] is shown to the user, allowing
  /// them to deny or allow the app to send them local notifications.
  ///
  /// To by-pass the explanation (not recommended), use
  /// [PermissionHandlerWrapper.requestNotification].
  Future<void> requestPermissionIfNeeded(
    BuildContext context,
    String userFacingDescription,
  ) async {
    // Request notification permission if they've never been requested before.
    if (!(await PermissionHandlerWrapper.get.isNotificationDenied)) {
      return;
    }
    if (context.mounted) {
      present(context, NotificationPermissionPage(userFacingDescription));
    }
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
