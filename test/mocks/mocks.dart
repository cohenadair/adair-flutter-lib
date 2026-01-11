import 'package:adair_flutter_lib/adair_flutter_lib.dart';
import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/managers/properties_manager.dart';
import 'package:adair_flutter_lib/managers/subscription_manager.dart';
import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:adair_flutter_lib/utils/log.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/device_info_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/firebase_auth_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/io_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/local_notifications_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/native_time_zone_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/permission_handler_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/purchases_wrapper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mockito/annotations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@GenerateMocks([AdairFlutterLib])
@GenerateMocks([AppConfig])
@GenerateMocks([CrashlyticsWrapper])
@GenerateMocks([CustomerInfo])
@GenerateMocks([DeviceInfoWrapper])
@GenerateMocks([EntitlementInfo])
@GenerateMocks([EntitlementInfos])
@GenerateMocks([FlutterLocalNotificationsPlugin])
@GenerateMocks([IoWrapper])
@GenerateMocks([IntroductoryPrice])
@GenerateMocks([LocalNotificationsWrapper])
@GenerateMocks(
  [],
  customMocks: [
    MockSpec<Log>(unsupportedMembers: {Symbol("sync"), Symbol("async")}),
  ],
)
@GenerateMocks([LogInResult])
@GenerateMocks([NativeTimeZoneWrapper])
@GenerateMocks([Offering])
@GenerateMocks([Offerings])
@GenerateMocks([Package])
@GenerateMocks([PermissionHandlerWrapper])
@GenerateMocks([PlatformException])
@GenerateMocks([PropertiesManager])
@GenerateMocks([PurchasesWrapper])
@GenerateMocks([StoreProduct])
@GenerateMocks([SubscriptionManager])
@GenerateMocks([TimeManager])
@GenerateMocks([TimeZoneLocation])
@GenerateMocks([AndroidBuildVersion])
@GenerateMocks([AndroidDeviceInfo])
@GenerateMocks([IosDeviceInfo])
@GenerateMocks([FirebaseAuthWrapper])
@GenerateMocks([User])
@GenerateMocks([UserCredential])
void main() {}
