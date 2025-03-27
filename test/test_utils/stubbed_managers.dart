import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/managers/properties_manager.dart';
import 'package:adair_flutter_lib/managers/subscription_manager.dart';
import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/io_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/native_time_zone_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/purchases_wrapper.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

class StubbedManagers {
  late final MockAppConfig appConfig;
  late final MockPropertiesManager propertiesManager;
  late final MockSubscriptionManager subscriptionManager;
  late final MockTimeManager timeManager;

  late final MockCrashlyticsWrapper crashlyticsWrapper;
  late final MockIoWrapper ioWrapper;
  late final MockNativeTimeZoneWrapper nativeTimeZoneWrapper;
  late final MockPurchasesWrapper purchasesWrapper;

  StubbedManagers() {
    appConfig = MockAppConfig();
    AppConfig.set(appConfig);

    propertiesManager = MockPropertiesManager();
    when(propertiesManager.init()).thenAnswer((_) => Future.value());
    PropertiesManager.set(propertiesManager);

    subscriptionManager = MockSubscriptionManager();
    when(subscriptionManager.init()).thenAnswer((_) => Future.value());
    SubscriptionManager.set(subscriptionManager);

    timeManager = MockTimeManager();
    when(timeManager.init()).thenAnswer((_) => Future.value());
    TimeManager.set(timeManager);

    crashlyticsWrapper = MockCrashlyticsWrapper();
    CrashlyticsWrapper.set(crashlyticsWrapper);

    ioWrapper = MockIoWrapper();
    IoWrapper.set(ioWrapper);

    nativeTimeZoneWrapper = MockNativeTimeZoneWrapper();
    NativeTimeZoneWrapper.set(nativeTimeZoneWrapper);

    purchasesWrapper = MockPurchasesWrapper();
    PurchasesWrapper.set(purchasesWrapper);
  }
}
