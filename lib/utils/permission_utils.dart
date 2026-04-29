import '../wrappers/device_info_wrapper.dart';
import '../wrappers/io_wrapper.dart';
import '../wrappers/permission_handler_wrapper.dart';

/// Requests all permissions required to access photos on the current platform.
/// Returns true only if all required permissions are granted.
Future<bool> requestPhotosPermission() async {
  var result = true;
  var isAndroid = IoWrapper.get.isAndroid;
  if (isAndroid) {
    result &= await PermissionHandlerWrapper.get.requestAccessMediaLocation();
  }

  // TODO: Necessary until
  //  https://github.com/Baseflow/flutter-permission-handler/issues/944 is
  //  fixed. Permission.photos.request() always returns denied on Android 12
  //  and below.
  if (isAndroid &&
      (await DeviceInfoWrapper.get.androidInfo).version.sdkInt <= 32) {
    result &= await PermissionHandlerWrapper.get.requestStorage();
  } else {
    result &= await PermissionHandlerWrapper.get.requestPhotos();
  }

  return result;
}
