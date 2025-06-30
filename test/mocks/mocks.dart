import 'package:adair_flutter_lib/adair_flutter_lib.dart';
import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/managers/properties_manager.dart';
import 'package:adair_flutter_lib/managers/subscription_manager.dart';
import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/io_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/native_time_zone_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/purchases_wrapper.dart';
import 'package:flutter/services.dart';
import 'package:mockito/annotations.dart';

import 'package:purchases_flutter/purchases_flutter.dart';

@GenerateMocks([AdairFlutterLib])
@GenerateMocks([AppConfig])
@GenerateMocks([CrashlyticsWrapper])
@GenerateMocks([CustomerInfo])
@GenerateMocks([EntitlementInfo])
@GenerateMocks([EntitlementInfos])
@GenerateMocks([IoWrapper])
@GenerateMocks([IntroductoryPrice])
@GenerateMocks([LogInResult])
@GenerateMocks([NativeTimeZoneWrapper])
@GenerateMocks([Offering])
@GenerateMocks([Offerings])
@GenerateMocks([Package])
@GenerateMocks([PlatformException])
@GenerateMocks([PropertiesManager])
@GenerateMocks([PurchasesWrapper])
@GenerateMocks([StoreProduct])
@GenerateMocks([SubscriptionManager])
@GenerateMocks([TimeManager])
void main() {}
