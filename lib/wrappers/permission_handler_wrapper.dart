import 'package:adair_flutter_lib/wrappers/io_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'device_info_wrapper.dart';

class PermissionHandlerWrapper {
  static var _instance = PermissionHandlerWrapper._();

  static PermissionHandlerWrapper get get => _instance;

  @visibleForTesting
  static void set(PermissionHandlerWrapper manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = PermissionHandlerWrapper._();

  PermissionHandlerWrapper._();

  Future<bool> requestLocation() async =>
      (await Permission.location.request()).isGranted;

  Future<bool> get isLocationGranted async => Permission.location.isGranted;

  Future<bool> requestLocationAlways() async =>
      (await Permission.locationAlways.request()).isGranted;

  Future<bool> get isLocationAlwaysGranted async =>
      Permission.locationAlways.isGranted;

  Future<bool> requestPhotos() async {
    var result = true;
    var isAndroid = IoWrapper.get.isAndroid;
    if (isAndroid) {
      result &= (await Permission.accessMediaLocation.request()).isGranted;
    }

    // TODO: Necessary until
    //  https://github.com/Baseflow/flutter-permission-handler/issues/944 is
    //  fixed. Permission.photos.request() always returns denied on Android 12
    //  and below.
    if (isAndroid &&
        (await DeviceInfoWrapper.get.androidInfo).version.sdkInt <= 32) {
      result &= (await Permission.storage.request()).isGranted;
    } else {
      result &= (await Permission.photos.request()).isGranted;
    }

    return result;
  }

  /// Observed behaviour:
  ///   - On an iOS fresh install, returns [PermissionStatus.denied]
  ///     immediately if Podfile isn't updated. See
  ///     https://github.com/Baseflow/flutter-permission-handler/issues/1497#issuecomment-3361080105
  ///     for details.
  ///   - User selects "Don't Allow", returns
  ///     [PermissionStatus.permanentlyDenied].
  ///   - User selects "Allow", returns [PermissionStatus.granted].
  Future<bool> requestNotification() async =>
      (await _notification.request()).isGranted;

  Future<bool> get isNotificationDenied => _notification.isDenied;

  Future<bool> get isNotificationGranted => _notification.isGranted;

  Permission get _notification => Permission.notification;

  Future<bool> openSettings() => openAppSettings();
}
