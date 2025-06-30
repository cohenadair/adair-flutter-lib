import 'package:adair_flutter_lib/adair_flutter_lib.dart';
import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/managers/properties_manager.dart';
import 'package:adair_flutter_lib/managers/subscription_manager.dart';
import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/io_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/native_time_zone_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/purchases_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import 'test_time_manager.dart';

class StubbedManagers {
  late final MockAdairFlutterLib adairFlutterLib;
  late final MockAppConfig appConfig;
  late final MockPropertiesManager propertiesManager;
  late final MockSubscriptionManager subscriptionManager;

  late final MockCrashlyticsWrapper crashlyticsWrapper;
  late final MockIoWrapper ioWrapper;
  late final MockNativeTimeZoneWrapper nativeTimeZoneWrapper;
  late final MockPurchasesWrapper purchasesWrapper;

  late final TestTimeManager timeManager;

  static Future<StubbedManagers> create() async {
    var result = StubbedManagers._();
    await result._initTimeManager();
    return result;
  }

  StubbedManagers._() {
    adairFlutterLib = MockAdairFlutterLib();
    when(adairFlutterLib.init()).thenAnswer((_) => Future.value());
    AdairFlutterLib.set(adairFlutterLib);

    appConfig = MockAppConfig();
    when(appConfig.colorAppTheme).thenReturn(Colors.pink);
    when(appConfig.appIcon).thenReturn(Icons.add); // Random icon.
    when(appConfig.appName).thenReturn((_) => "Test App");
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

    timeManager = TestTimeManager();
    TimeManager.set(timeManager);
  }

  /// Initializes the real [TimeManager] instance with a default time zone. If
  /// needed, apps can create a [MockTimeManager] and call [TimeManager.set].
  Future<void> _initTimeManager() async {
    when(
      nativeTimeZoneWrapper.getAvailableTimeZones(),
    ).thenAnswer((_) => Future.value([timeManager.timeZone]));
    when(
      nativeTimeZoneWrapper.getLocalTimeZone(),
    ).thenAnswer((_) => Future.value(timeManager.timeZone));

    return timeManager.init();
  }
}
