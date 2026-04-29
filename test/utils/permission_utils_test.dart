import 'package:adair_flutter_lib/utils/permission_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
    when(
      managers.permissionHandlerWrapper.requestAccessMediaLocation(),
    ).thenAnswer((_) async => true);
    when(
      managers.permissionHandlerWrapper.requestPhotos(),
    ).thenAnswer((_) async => true);
    when(
      managers.permissionHandlerWrapper.requestStorage(),
    ).thenAnswer((_) async => true);
  });

  test(
    "requestPhotosPermission on non-Android calls only requestPhotos",
    () async {
      managers.stubIosDeviceInfo();

      final result = await requestPhotosPermission();

      verifyNever(
        managers.permissionHandlerWrapper.requestAccessMediaLocation(),
      );
      verifyNever(managers.permissionHandlerWrapper.requestStorage());
      verify(managers.permissionHandlerWrapper.requestPhotos()).called(1);
      expect(result, isTrue);
    },
  );

  test(
    "requestPhotosPermission on Android SDK > 32 calls requestAccessMediaLocation and requestPhotos",
    () async {
      managers.stubAndroidDeviceInfo(sdkInt: 33);

      final result = await requestPhotosPermission();

      verify(
        managers.permissionHandlerWrapper.requestAccessMediaLocation(),
      ).called(1);
      verify(managers.permissionHandlerWrapper.requestPhotos()).called(1);
      verifyNever(managers.permissionHandlerWrapper.requestStorage());
      expect(result, isTrue);
    },
  );

  test(
    "requestPhotosPermission on Android SDK <= 32 calls requestAccessMediaLocation and requestStorage",
    () async {
      managers.stubAndroidDeviceInfo(sdkInt: 32);

      final result = await requestPhotosPermission();

      verify(
        managers.permissionHandlerWrapper.requestAccessMediaLocation(),
      ).called(1);
      verify(managers.permissionHandlerWrapper.requestStorage()).called(1);
      verifyNever(managers.permissionHandlerWrapper.requestPhotos());
      expect(result, isTrue);
    },
  );

  test(
    "requestPhotosPermission returns false when a permission is denied",
    () async {
      managers.stubIosDeviceInfo();
      when(
        managers.permissionHandlerWrapper.requestPhotos(),
      ).thenAnswer((_) async => false);

      final result = await requestPhotosPermission();

      expect(result, isFalse);
    },
  );
}
