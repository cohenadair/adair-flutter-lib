import '../wrappers/io_wrapper.dart';
import '../wrappers/permission_handler_wrapper.dart';

/// Requests all permissions required to access photos on the current platform.
/// Returns true only if all required permissions are granted.
Future<bool> requestPhotosPermission() async {
  if (IoWrapper.get.isIOS) {
    // iOS: the photo library permission is required for photo_manager.
    return PermissionHandlerWrapper.get.requestPhotos();
  }

  // Android: the Android Photo Picker handles gallery access without any
  // storage permissions. Only ACCESS_MEDIA_LOCATION is needed to preserve
  // GPS EXIF coordinates from selected photos.
  return PermissionHandlerWrapper.get.requestAccessMediaLocation();
}
