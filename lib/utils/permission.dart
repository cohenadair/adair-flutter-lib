import '../wrappers/io_wrapper.dart';
import '../wrappers/permission_handler_wrapper.dart';
import 'log.dart';

final _log = Log("Permission");

/// Requests all permissions required to access photos on the current platform.
/// Returns true only if all required permissions are granted.
Future<bool> requestPhotosPermission() async {
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

/// Requests notification permission.
Future<bool> requestNotificationPermission() =>
    _requestGranted(PermissionHandlerWrapper.get.requestNotification);

/// Requests location permission.
Future<bool> requestLocationPermission() =>
    _requestGranted(PermissionHandlerWrapper.get.requestLocation);

/// Requests "always" (background) location permission.
Future<bool> requestLocationAlwaysPermission() =>
    _requestGranted(PermissionHandlerWrapper.get.requestLocationAlways);

/// Requests storage permission.
Future<bool> requestStoragePermission() =>
    _requestGranted(PermissionHandlerWrapper.get.requestStorage);

/// The underlying permission_handler plugin throws a [PlatformException] if
/// a request for any permission is already in progress when this is called
/// (e.g. from overlapping calls to different request functions above). Treat
/// that, and any other unexpected failure, as "not granted" rather than
/// crashing.
Future<bool> _requestGranted(Future<bool> Function() request) async {
  try {
    return await request();
  } catch (e) {
    _log.e(e, reason: "Failed to request permission");
    return false;
  }
}
