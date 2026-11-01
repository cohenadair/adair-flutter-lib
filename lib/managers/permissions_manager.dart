import 'package:flutter/foundation.dart';

import '../utils/log.dart';
import '../wrappers/io_wrapper.dart';
import '../wrappers/permission_handler_wrapper.dart';

final _log = const Log("PermissionsManager");

/// Requests runtime permissions one at a time.
///
/// The underlying permission_handler plugin throws a [PlatformException] if
/// a request for any permission is already in progress (e.g. a second tap on
/// a "current location" button before the OS prompt from the first appears).
/// To avoid that, requests are queued: a request for a permission that's
/// already being requested shares that request's result, and any other
/// request waits for the in-progress one to finish.
class PermissionsManager {
  static var _instance = PermissionsManager._();

  static PermissionsManager get get => _instance;

  @visibleForTesting
  static void set(PermissionsManager manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = PermissionsManager._();

  PermissionsManager._();

  /// The most recently queued request, or null if none are in progress.
  Future<bool>? _lastRequest;

  /// Requests that haven't finished yet, keyed by request function.
  final _requestsInProgress = <Future<bool> Function(), Future<bool>>{};

  /// Requests all permissions required to access photos on the current
  /// platform. Returns true only if all required permissions are granted.
  Future<bool> requestPhotos() {
    if (IoWrapper.get.isIOS) {
      // iOS: the photo library permission is required for photo_manager.
      return _requestGranted(PermissionHandlerWrapper.get.requestPhotos);
    }

    // Android: the Android Photo Picker handles gallery access without any
    // storage permissions. Only ACCESS_MEDIA_LOCATION is needed to preserve
    // GPS EXIF coordinates from selected photos.
    return _requestGranted(
      PermissionHandlerWrapper.get.requestAccessMediaLocation,
    );
  }

  Future<bool> requestNotification() =>
      _requestGranted(PermissionHandlerWrapper.get.requestNotification);

  Future<bool> requestLocation() =>
      _requestGranted(PermissionHandlerWrapper.get.requestLocation);

  /// Requests "always" (background) location permission.
  Future<bool> requestLocationAlways() =>
      _requestGranted(PermissionHandlerWrapper.get.requestLocationAlways);

  Future<bool> requestStorage() =>
      _requestGranted(PermissionHandlerWrapper.get.requestStorage);

  Future<bool> _requestGranted(Future<bool> Function() request) {
    final inProgress = _requestsInProgress[request];
    if (inProgress != null) {
      return inProgress;
    }

    final previous = _lastRequest;
    late final Future<bool> result;
    result =
        (previous == null
                ? _request(request)
                : previous.then((_) => _request(request)))
            .whenComplete(() {
              _requestsInProgress.remove(request);
              if (identical(_lastRequest, result)) {
                _lastRequest = null;
              }
            });
    _requestsInProgress[request] = result;
    _lastRequest = result;
    return result;
  }

  /// Treats an unexpected failure as "not granted" rather than crashing.
  /// Never throws, so a failed request doesn't break the queue in
  /// [_requestGranted].
  Future<bool> _request(Future<bool> Function() request) async {
    try {
      return await request();
    } catch (e) {
      _log.e(e, reason: "Failed to request permission");
      return false;
    }
  }
}
