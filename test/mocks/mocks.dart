import 'package:adair_flutter_lib/adair_flutter_lib.dart';
import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/managers/properties_manager.dart';
import 'package:adair_flutter_lib/managers/subscription_manager.dart';
import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:adair_flutter_lib/utils/log.dart';
import 'package:adair_flutter_lib/wrappers/analytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/device_info_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/file_picker_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/firebase_auth_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/firebase_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/firestore_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/functions_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/io_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/local_notifications_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/native_time_zone_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/permission_handler_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/purchases_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/storage_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mockito/annotations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@GenerateMocks([AdairFlutterLib])
@GenerateMocks([AnalyticsWrapper])
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
@GenerateMocks([FilePickerWrapper])
@GenerateMocks([StorageWrapper])
@GenerateMocks([FirebaseAuthWrapper])
@GenerateMocks([IdTokenResult])
@GenerateMocks([FirebaseWrapper])
@GenerateMocks([FirestoreWrapper])
@GenerateMocks([FunctionsWrapper])
@GenerateMocks([HttpsCallable])
@GenerateMocks([User])
@GenerateMocks([UserCredential])
@GenerateMocks(
  [],
  customMocks: [
    MockSpec<CollectionReference<Map<String, dynamic>>>(
      as: #MockCollectionReference,
    ),
    MockSpec<DocumentReference<Map<String, dynamic>>>(
      as: #MockDocumentReference,
    ),
    MockSpec<QuerySnapshot<Map<String, dynamic>>>(as: #MockQuerySnapshot),
    MockSpec<QueryDocumentSnapshot<Map<String, dynamic>>>(
      as: #MockQueryDocumentSnapshot,
    ),
    MockSpec<WriteBatch>(as: #MockWriteBatch),
  ],
)
void main() {}
