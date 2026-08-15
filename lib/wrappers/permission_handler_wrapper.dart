import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/log.dart';

final _log = Log("PermissionHandlerWrapper");

class PermissionHandlerWrapper {
  static var _instance = PermissionHandlerWrapper._();

  static PermissionHandlerWrapper get get => _instance;

  @visibleForTesting
  static void set(PermissionHandlerWrapper manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = PermissionHandlerWrapper._();

  PermissionHandlerWrapper._();

  Future<bool> requestLocation() => _requestGranted(Permission.location);

  Future<bool> get isLocationGranted async => Permission.location.isGranted;

  Future<bool> requestLocationAlways() =>
      _requestGranted(Permission.locationAlways);

  Future<bool> get isLocationAlwaysGranted async =>
      Permission.locationAlways.isGranted;

  // TODO: Make private to adair-flutter-lib, if possible.
  /// Don't call directly. Call `permission_utils.dart`'s
  /// `requestPhotosPermission()` instead.
  Future<bool> requestAccessMediaLocation() =>
      _requestGranted(Permission.accessMediaLocation);

  Future<bool> requestStorage() => _requestGranted(Permission.storage);

  // TODO: Make private to adair-flutter-lib, if possible.
  /// Don't call directly. Call `permission_utils.dart`'s
  /// `requestPhotosPermission()` instead.
  Future<bool> requestPhotos() => _requestGranted(Permission.photos);

  /// Observed behaviour:
  ///   - On an iOS fresh install, returns [PermissionStatus.denied]
  ///     immediately if Podfile isn't updated. See
  ///     https://github.com/Baseflow/flutter-permission-handler/issues/1497#issuecomment-3361080105
  ///     for details.
  ///   - User selects "Don't Allow", returns
  ///     [PermissionStatus.permanentlyDenied].
  ///   - User selects "Allow", returns [PermissionStatus.granted].
  Future<bool> requestNotification() => _requestGranted(_notification);

  Future<bool> get isNotificationDenied => _notification.isDenied;

  Future<bool> get isNotificationGranted => _notification.isGranted;

  Permission get _notification => Permission.notification;

  Future<bool> openSettings() => openAppSettings();

  /// The underlying plugin throws a [PlatformException] if a request for
  /// any permission is already in progress when this is called (e.g. from
  /// overlapping calls to different request* methods above). Treat that,
  /// and any other unexpected failure, as "not granted" rather than
  /// crashing.
  Future<bool> _requestGranted(Permission permission) async {
    try {
      return (await permission.request()).isGranted;
    } catch (e) {
      _log.e(e, reason: "Failed to request permission: $permission");
      return false;
    }
  }
}
