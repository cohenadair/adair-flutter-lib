import 'package:adair_flutter_lib/adair_flutter_lib.dart';
import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/managers/properties_manager.dart';
import 'package:adair_flutter_lib/managers/subscription_manager.dart';
import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/device_info_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/firebase_auth_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/io_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/local_notifications_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/native_time_zone_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/permission_handler_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/purchases_wrapper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:quiver/strings.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';

import '../mocks/mocks.mocks.dart';

class StubbedManagers {
  late final MockAdairFlutterLib adairFlutterLib;
  late final MockAppConfig appConfig;
  late final MockPropertiesManager propertiesManager;
  late final MockSubscriptionManager subscriptionManager;
  late final MockTimeManager timeManager;

  late final MockCrashlyticsWrapper crashlyticsWrapper;
  late final MockDeviceInfoWrapper deviceInfoWrapper;
  late final MockFirebaseAuthWrapper firebaseAuthWrapper;
  late final MockIoWrapper ioWrapper;
  late final MockLocalNotificationsWrapper localNotificationsWrapper;
  late final MockNativeTimeZoneWrapper nativeTimeZoneWrapper;
  late final MockPermissionHandlerWrapper permissionHandlerWrapper;
  late final MockPurchasesWrapper purchasesWrapper;

  // TODO: Remove the Future return type.
  static Future<StubbedManagers> create() async {
    return StubbedManagers._();
  }

  StubbedManagers._() {
    adairFlutterLib = MockAdairFlutterLib();
    when(adairFlutterLib.init()).thenAnswer((_) => Future.value());
    AdairFlutterLib.set(adairFlutterLib);

    appConfig = MockAppConfig();
    when(appConfig.colorAppTheme).thenReturn(Colors.pink);
    when(appConfig.colorAppBarContent).thenReturn((_) => Colors.white);
    when(appConfig.appIcon).thenReturn(Icons.add); // Random icon.
    when(appConfig.appName).thenReturn(() => "Test App");
    when(appConfig.themeMode).thenReturn(() => ThemeMode.system);
    AppConfig.set(appConfig);

    propertiesManager = MockPropertiesManager();
    when(propertiesManager.init()).thenAnswer((_) => Future.value());
    when(propertiesManager.stringForKey(any)).thenReturn("");
    PropertiesManager.set(propertiesManager);

    subscriptionManager = MockSubscriptionManager();
    when(subscriptionManager.init()).thenAnswer((_) => Future.value());
    SubscriptionManager.set(subscriptionManager);

    crashlyticsWrapper = MockCrashlyticsWrapper();
    CrashlyticsWrapper.set(crashlyticsWrapper);

    ioWrapper = MockIoWrapper();
    IoWrapper.set(ioWrapper);

    nativeTimeZoneWrapper = MockNativeTimeZoneWrapper();
    NativeTimeZoneWrapper.set(nativeTimeZoneWrapper);

    purchasesWrapper = MockPurchasesWrapper();
    PurchasesWrapper.set(purchasesWrapper);

    timeManager = MockTimeManager();
    stubCurrentTime(DateTime.now());
    TimeManager.set(timeManager);

    deviceInfoWrapper = MockDeviceInfoWrapper();
    DeviceInfoWrapper.set(deviceInfoWrapper);

    firebaseAuthWrapper = MockFirebaseAuthWrapper();
    FirebaseAuthWrapper.set(firebaseAuthWrapper);

    localNotificationsWrapper = MockLocalNotificationsWrapper();
    LocalNotificationsWrapper.set(localNotificationsWrapper);

    permissionHandlerWrapper = MockPermissionHandlerWrapper();
    PermissionHandlerWrapper.set(permissionHandlerWrapper);
  }

  void stubCurrentTime(DateTime now, {String timeZone = "America/New_York"}) {
    initializeTimeZones();

    final defaultLocation = getLocation(timeZone);
    final tzNow = TZDateTime.from(now, defaultLocation);
    when(timeManager.now(any)).thenReturn(tzNow);
    when(timeManager.currentDateTime).thenReturn(tzNow);
    when(timeManager.currentTime).thenReturn(TimeOfDay.fromDateTime(tzNow));
    when(timeManager.currentTimestamp).thenReturn(tzNow.millisecondsSinceEpoch);

    when(
      timeManager.currentLocation,
    ).thenReturn(TimeZoneLocation.fromName(timeZone));
    when(timeManager.currentTimeZone).thenReturn(timeZone);
    when(timeManager.dateTime(any, any)).thenAnswer((invocation) {
      String? tz = invocation.positionalArguments.length == 2
          ? invocation.positionalArguments[1]
          : null;
      if (isEmpty(tz)) {
        tz = timeZone;
      }
      return TZDateTime.fromMillisecondsSinceEpoch(
        getLocation(tz!),
        invocation.positionalArguments[0],
      );
    });
    when(timeManager.dateTimeToTz(any)).thenAnswer(
      (invocation) => TZDateTime.from(
        invocation.positionalArguments.first,
        defaultLocation,
      ),
    );
    when(
      timeManager.dateTimeFromValues(any, any, any, any, any, any, any, any),
    ).thenAnswer(
      (invocation) => TZDateTime(
        defaultLocation,
        invocation.positionalArguments[0],
        invocation.positionalArguments[1],
        invocation.positionalArguments[2],
        invocation.positionalArguments[3],
        invocation.positionalArguments[4],
        invocation.positionalArguments[5],
        invocation.positionalArguments[6],
        invocation.positionalArguments[7],
      ),
    );

    when(
      nativeTimeZoneWrapper.getAvailableTimeZones(),
    ).thenAnswer((_) => Future.value([timeManager.currentTimeZone]));
    when(
      nativeTimeZoneWrapper.getLocalTimeZone(),
    ).thenAnswer((_) => Future.value(timeManager.currentTimeZone));
  }

  void stubIosDeviceInfo({
    String? iosVersion = "17.0.0",
    String? machine = "iPhone Name",
  }) {
    when(ioWrapper.isIOS).thenReturn(true);
    when(ioWrapper.isAndroid).thenReturn(false);

    when(deviceInfoWrapper.iosInfo).thenAnswer(
      (_) => Future.value(
        IosDeviceInfo.fromMap({
          "freeDiskSize": 0,
          "totalDiskSize": 0,
          "physicalRamSize": 0,
          "availableRamSize": 0,
          "name": "iOS Device Info",
          "systemName": "iOS System",
          "systemVersion": iosVersion,
          "model": "iPhone",
          "modelName": "14 Pro",
          "localizedModel": "iPhone",
          "identifierForVendor": "Vendor ID",
          "isPhysicalDevice": true,
          "isiOSAppOnMac": false,
          "utsname": {
            "sysname": "Sys name",
            "nodename": "Node name",
            "release": "Release",
            "version": "Version",
            "machine": machine,
          },
        }),
      ),
    );
  }

  void stubAndroidDeviceInfo({int sdkInt = 33}) {
    when(ioWrapper.isIOS).thenReturn(false);
    when(ioWrapper.isAndroid).thenReturn(true);

    final buildVersion = MockAndroidBuildVersion();
    when(buildVersion.sdkInt).thenReturn(sdkInt);

    final deviceInfo = MockAndroidDeviceInfo();
    when(deviceInfo.version).thenReturn(buildVersion);
    when(deviceInfo.model).thenReturn("Pixel XL");
    when(deviceInfo.id).thenReturn("ABCD1234");

    when(
      deviceInfoWrapper.androidInfo,
    ).thenAnswer((_) => Future.value(deviceInfo));
  }
}
