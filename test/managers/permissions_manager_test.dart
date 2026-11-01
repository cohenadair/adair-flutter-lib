import 'dart:async';

import 'package:adair_flutter_lib/managers/permissions_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
    // StubbedManagers sets a mock; use the real manager here.
    PermissionsManager.reset();

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

  test("requestPhotos on non-Android calls only requestPhotos", () async {
    managers.stubIosDeviceInfo();

    final result = await PermissionsManager.get.requestPhotos();

    verifyNever(managers.permissionHandlerWrapper.requestAccessMediaLocation());
    verify(managers.permissionHandlerWrapper.requestPhotos()).called(1);
    expect(result, isTrue);
  });

  test("requestPhotos returns false when a permission is denied", () async {
    managers.stubIosDeviceInfo();
    when(
      managers.permissionHandlerWrapper.requestPhotos(),
    ).thenAnswer((_) async => false);

    final result = await PermissionsManager.get.requestPhotos();

    expect(result, isFalse);
  });

  test(
    "requestPhotos on Android calls only requestAccessMediaLocation",
    () async {
      managers.stubAndroidDeviceInfo();

      final result = await PermissionsManager.get.requestPhotos();

      verify(
        managers.permissionHandlerWrapper.requestAccessMediaLocation(),
      ).called(1);
      verifyNever(managers.permissionHandlerWrapper.requestPhotos());
      expect(result, isTrue);
    },
  );

  test(
    "requestPhotos on Android returns false when permission denied",
    () async {
      managers.stubAndroidDeviceInfo();
      when(
        managers.permissionHandlerWrapper.requestAccessMediaLocation(),
      ).thenAnswer((_) async => false);

      final result = await PermissionsManager.get.requestPhotos();

      expect(result, isFalse);
    },
  );

  test("requestNotification calls the wrapper's requestNotification", () async {
    final result = await PermissionsManager.get.requestNotification();

    verify(managers.permissionHandlerWrapper.requestNotification()).called(1);
    expect(result, isTrue);
  });

  test("requestLocation calls the wrapper's requestLocation", () async {
    final result = await PermissionsManager.get.requestLocation();

    verify(managers.permissionHandlerWrapper.requestLocation()).called(1);
    expect(result, isTrue);
  });

  test(
    "requestLocationAlways calls the wrapper's requestLocationAlways",
    () async {
      final result = await PermissionsManager.get.requestLocationAlways();

      verify(
        managers.permissionHandlerWrapper.requestLocationAlways(),
      ).called(1);
      expect(result, isTrue);
    },
  );

  test("requestStorage calls the wrapper's requestStorage", () async {
    final result = await PermissionsManager.get.requestStorage();

    verify(managers.permissionHandlerWrapper.requestStorage()).called(1);
    expect(result, isTrue);
  });

  test("requestNotification returns false when the wrapper throws", () async {
    when(
      managers.permissionHandlerWrapper.requestNotification(),
    ).thenThrow(Exception("already running"));

    final result = await PermissionsManager.get.requestNotification();

    expect(result, isFalse);
  });

  test(
    "Concurrent requests for the same permission share one request",
    () async {
      final request = Completer<bool>();
      when(
        managers.permissionHandlerWrapper.requestLocation(),
      ).thenAnswer((_) => request.future);

      final first = PermissionsManager.get.requestLocation();
      final second = PermissionsManager.get.requestLocation();
      request.complete(true);

      expect(await Future.wait([first, second]), [true, true]);
      verify(managers.permissionHandlerWrapper.requestLocation()).called(1);
    },
  );

  test(
    "A request waits for a different in-progress request to finish",
    () async {
      final location = Completer<bool>();
      when(
        managers.permissionHandlerWrapper.requestLocation(),
      ).thenAnswer((_) => location.future);

      final first = PermissionsManager.get.requestLocation();
      final second = PermissionsManager.get.requestNotification();
      await pumpEventQueue();

      // Overlapping requests make permission_handler throw "a request for
      // permissions is already running", so the second must not start yet.
      verifyNever(managers.permissionHandlerWrapper.requestNotification());

      location.complete(true);
      expect(await Future.wait([first, second]), [true, true]);
      verify(managers.permissionHandlerWrapper.requestNotification()).called(1);
    },
  );

  test("A failed request doesn't block the next request", () async {
    when(
      managers.permissionHandlerWrapper.requestLocation(),
    ).thenThrow(Exception("already running"));

    final first = PermissionsManager.get.requestLocation();
    final second = PermissionsManager.get.requestNotification();

    expect(await Future.wait([first, second]), [false, true]);
  });

  test(
    "A permission can be requested again after its request finishes",
    () async {
      await PermissionsManager.get.requestLocation();
      await PermissionsManager.get.requestLocation();

      verify(managers.permissionHandlerWrapper.requestLocation()).called(2);
    },
  );
}
