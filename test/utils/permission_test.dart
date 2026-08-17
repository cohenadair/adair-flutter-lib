import 'package:adair_flutter_lib/utils/permission.dart';
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
    when(
      managers.permissionHandlerWrapper.requestNotification(),
    ).thenAnswer((_) async => true);
    when(
      managers.permissionHandlerWrapper.requestLocation(),
    ).thenAnswer((_) async => true);
    when(
      managers.permissionHandlerWrapper.requestLocationAlways(),
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
      verify(managers.permissionHandlerWrapper.requestPhotos()).called(1);
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

  test(
    "requestPhotosPermission on Android calls only requestAccessMediaLocation",
    () async {
      managers.stubAndroidDeviceInfo();

      final result = await requestPhotosPermission();

      verify(
        managers.permissionHandlerWrapper.requestAccessMediaLocation(),
      ).called(1);
      verifyNever(managers.permissionHandlerWrapper.requestPhotos());
      expect(result, isTrue);
    },
  );

  test(
    "requestPhotosPermission on Android returns false when permission denied",
    () async {
      managers.stubAndroidDeviceInfo();
      when(
        managers.permissionHandlerWrapper.requestAccessMediaLocation(),
      ).thenAnswer((_) async => false);

      final result = await requestPhotosPermission();

      expect(result, isFalse);
    },
  );

  test("requestNotificationPermission calls requestNotification", () async {
    final result = await requestNotificationPermission();

    verify(managers.permissionHandlerWrapper.requestNotification()).called(1);
    expect(result, isTrue);
  });

  test("requestLocationPermission calls requestLocation", () async {
    final result = await requestLocationPermission();

    verify(managers.permissionHandlerWrapper.requestLocation()).called(1);
    expect(result, isTrue);
  });

  test("requestLocationAlwaysPermission calls requestLocationAlways", () async {
    final result = await requestLocationAlwaysPermission();

    verify(managers.permissionHandlerWrapper.requestLocationAlways()).called(1);
    expect(result, isTrue);
  });

  test("requestStoragePermission calls requestStorage", () async {
    final result = await requestStoragePermission();

    verify(managers.permissionHandlerWrapper.requestStorage()).called(1);
    expect(result, isTrue);
  });

  test(
    "requestNotificationPermission returns false when the wrapper throws",
    () async {
      when(
        managers.permissionHandlerWrapper.requestNotification(),
      ).thenThrow(Exception("already running"));

      final result = await requestNotificationPermission();

      expect(result, isFalse);
    },
  );
}
