// Mocks generated by Mockito 5.4.5 from annotations
// in adair_flutter_lib/test/mocks/mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i13;
import 'dart:io' as _i18;

import 'package:adair_flutter_lib/app_config.dart' as _i9;
import 'package:adair_flutter_lib/managers/properties_manager.dart' as _i22;
import 'package:adair_flutter_lib/managers/subscription_manager.dart' as _i24;
import 'package:adair_flutter_lib/managers/time_manager.dart' as _i8;
import 'package:adair_flutter_lib/utils/string.dart' as _i10;
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart' as _i12;
import 'package:adair_flutter_lib/wrappers/io_wrapper.dart' as _i17;
import 'package:adair_flutter_lib/wrappers/native_time_zone_wrapper.dart'
    as _i20;
import 'package:adair_flutter_lib/wrappers/purchases_wrapper.dart' as _i23;
import 'package:flutter/material.dart' as _i2;
import 'package:flutter/services.dart' as _i21;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i11;
import 'package:purchases_flutter/models/entitlement_info_wrapper.dart' as _i5;
import 'package:purchases_flutter/models/entitlement_infos_wrapper.dart' as _i3;
import 'package:purchases_flutter/models/period_unit.dart' as _i19;
import 'package:purchases_flutter/models/store.dart' as _i15;
import 'package:purchases_flutter/models/store_transaction.dart' as _i14;
import 'package:purchases_flutter/models/verification_result.dart' as _i16;
import 'package:purchases_flutter/object_wrappers.dart' as _i4;
import 'package:purchases_flutter/purchases_flutter.dart' as _i6;
import 'package:timezone/timezone.dart' as _i7;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeIconData_0 extends _i1.SmartFake implements _i2.IconData {
  _FakeIconData_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeMaterialColor_1 extends _i1.SmartFake implements _i2.MaterialColor {
  _FakeMaterialColor_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeEntitlementInfos_2 extends _i1.SmartFake
    implements _i3.EntitlementInfos {
  _FakeEntitlementInfos_2(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _Fake$CustomerInfoCopyWith_3<$Res> extends _i1.SmartFake
    implements _i4.$CustomerInfoCopyWith<$Res> {
  _Fake$CustomerInfoCopyWith_3(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _Fake$EntitlementInfoCopyWith_4<$Res> extends _i1.SmartFake
    implements _i5.$EntitlementInfoCopyWith<$Res> {
  _Fake$EntitlementInfoCopyWith_4(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _Fake$EntitlementInfosCopyWith_5<$Res> extends _i1.SmartFake
    implements _i3.$EntitlementInfosCopyWith<$Res> {
  _Fake$EntitlementInfosCopyWith_5(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _Fake$IntroductoryPriceCopyWith_6<$Res> extends _i1.SmartFake
    implements _i4.$IntroductoryPriceCopyWith<$Res> {
  _Fake$IntroductoryPriceCopyWith_6(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeCustomerInfo_7 extends _i1.SmartFake implements _i4.CustomerInfo {
  _FakeCustomerInfo_7(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _Fake$OfferingCopyWith_8<$Res> extends _i1.SmartFake
    implements _i4.$OfferingCopyWith<$Res> {
  _Fake$OfferingCopyWith_8(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _Fake$OfferingsCopyWith_9<$Res> extends _i1.SmartFake
    implements _i4.$OfferingsCopyWith<$Res> {
  _Fake$OfferingsCopyWith_9(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeStoreProduct_10 extends _i1.SmartFake implements _i4.StoreProduct {
  _FakeStoreProduct_10(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakePresentedOfferingContext_11 extends _i1.SmartFake
    implements _i4.PresentedOfferingContext {
  _FakePresentedOfferingContext_11(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _Fake$PackageCopyWith_12<$Res> extends _i1.SmartFake
    implements _i4.$PackageCopyWith<$Res> {
  _Fake$PackageCopyWith_12(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeOfferings_13 extends _i1.SmartFake implements _i4.Offerings {
  _FakeOfferings_13(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeLogInResult_14 extends _i1.SmartFake implements _i6.LogInResult {
  _FakeLogInResult_14(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _Fake$StoreProductCopyWith_15<$Res> extends _i1.SmartFake
    implements _i4.$StoreProductCopyWith<$Res> {
  _Fake$StoreProductCopyWith_15(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeTZDateTime_16 extends _i1.SmartFake implements _i7.TZDateTime {
  _FakeTZDateTime_16(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeTimeZoneLocation_17 extends _i1.SmartFake
    implements _i8.TimeZoneLocation {
  _FakeTimeZoneLocation_17(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeTimeOfDay_18 extends _i1.SmartFake implements _i2.TimeOfDay {
  _FakeTimeOfDay_18(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [AppConfig].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppConfig extends _i1.Mock implements _i9.AppConfig {
  MockAppConfig() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.StringCallback get appName => (super.noSuchMethod(
        Invocation.getter(#appName),
        returnValue: (_i2.BuildContext __p0) =>
            _i11.dummyValue<String>(this, Invocation.getter(#appName)),
      ) as _i10.StringCallback);

  @override
  set appName(_i10.StringCallback? _appName) => super.noSuchMethod(
        Invocation.setter(#appName, _appName),
        returnValueForMissingStub: null,
      );

  @override
  _i2.IconData get appIcon => (super.noSuchMethod(
        Invocation.getter(#appIcon),
        returnValue: _FakeIconData_0(this, Invocation.getter(#appIcon)),
      ) as _i2.IconData);

  @override
  set appIcon(_i2.IconData? _appIcon) => super.noSuchMethod(
        Invocation.setter(#appIcon, _appIcon),
        returnValueForMissingStub: null,
      );

  @override
  _i2.MaterialColor get colorAppTheme => (super.noSuchMethod(
        Invocation.getter(#colorAppTheme),
        returnValue: _FakeMaterialColor_1(
          this,
          Invocation.getter(#colorAppTheme),
        ),
      ) as _i2.MaterialColor);

  @override
  set colorAppTheme(_i2.MaterialColor? _colorAppTheme) => super.noSuchMethod(
        Invocation.setter(#colorAppTheme, _colorAppTheme),
        returnValueForMissingStub: null,
      );

  @override
  void init({
    required _i10.StringCallback? appName,
    _i2.IconData? appIcon,
    _i2.MaterialColor? colorAppTheme,
  }) =>
      super.noSuchMethod(
        Invocation.method(#init, [], {
          #appName: appName,
          #appIcon: appIcon,
          #colorAppTheme: colorAppTheme,
        }),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [CrashlyticsWrapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockCrashlyticsWrapper extends _i1.Mock
    implements _i12.CrashlyticsWrapper {
  MockCrashlyticsWrapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i13.Future<void> log(String? message) => (super.noSuchMethod(
        Invocation.method(#log, [message]),
        returnValue: _i13.Future<void>.value(),
        returnValueForMissingStub: _i13.Future<void>.value(),
      ) as _i13.Future<void>);

  @override
  _i13.Future<void> recordError(
    String? message,
    StackTrace? stack,
    String? reason,
  ) =>
      (super.noSuchMethod(
        Invocation.method(#recordError, [message, stack, reason]),
        returnValue: _i13.Future<void>.value(),
        returnValueForMissingStub: _i13.Future<void>.value(),
      ) as _i13.Future<void>);

  @override
  _i13.Future<void> setUserId(String? identifier) => (super.noSuchMethod(
        Invocation.method(#setUserId, [identifier]),
        returnValue: _i13.Future<void>.value(),
        returnValueForMissingStub: _i13.Future<void>.value(),
      ) as _i13.Future<void>);
}

/// A class which mocks [CustomerInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockCustomerInfo extends _i1.Mock implements _i4.CustomerInfo {
  MockCustomerInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.EntitlementInfos get entitlements => (super.noSuchMethod(
        Invocation.getter(#entitlements),
        returnValue: _FakeEntitlementInfos_2(
          this,
          Invocation.getter(#entitlements),
        ),
      ) as _i3.EntitlementInfos);

  @override
  Map<String, String?> get allPurchaseDates => (super.noSuchMethod(
        Invocation.getter(#allPurchaseDates),
        returnValue: <String, String?>{},
      ) as Map<String, String?>);

  @override
  List<String> get activeSubscriptions => (super.noSuchMethod(
        Invocation.getter(#activeSubscriptions),
        returnValue: <String>[],
      ) as List<String>);

  @override
  List<String> get allPurchasedProductIdentifiers => (super.noSuchMethod(
        Invocation.getter(#allPurchasedProductIdentifiers),
        returnValue: <String>[],
      ) as List<String>);

  @override
  List<_i14.StoreTransaction> get nonSubscriptionTransactions =>
      (super.noSuchMethod(
        Invocation.getter(#nonSubscriptionTransactions),
        returnValue: <_i14.StoreTransaction>[],
      ) as List<_i14.StoreTransaction>);

  @override
  String get firstSeen => (super.noSuchMethod(
        Invocation.getter(#firstSeen),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#firstSeen),
        ),
      ) as String);

  @override
  String get originalAppUserId => (super.noSuchMethod(
        Invocation.getter(#originalAppUserId),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#originalAppUserId),
        ),
      ) as String);

  @override
  Map<String, String?> get allExpirationDates => (super.noSuchMethod(
        Invocation.getter(#allExpirationDates),
        returnValue: <String, String?>{},
      ) as Map<String, String?>);

  @override
  String get requestDate => (super.noSuchMethod(
        Invocation.getter(#requestDate),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#requestDate),
        ),
      ) as String);

  @override
  _i4.$CustomerInfoCopyWith<_i4.CustomerInfo> get copyWith =>
      (super.noSuchMethod(
        Invocation.getter(#copyWith),
        returnValue: _Fake$CustomerInfoCopyWith_3<_i4.CustomerInfo>(
          this,
          Invocation.getter(#copyWith),
        ),
      ) as _i4.$CustomerInfoCopyWith<_i4.CustomerInfo>);

  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(#toJson, []),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
}

/// A class which mocks [EntitlementInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockEntitlementInfo extends _i1.Mock implements _i5.EntitlementInfo {
  MockEntitlementInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get identifier => (super.noSuchMethod(
        Invocation.getter(#identifier),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#identifier),
        ),
      ) as String);

  @override
  bool get isActive =>
      (super.noSuchMethod(Invocation.getter(#isActive), returnValue: false)
          as bool);

  @override
  bool get willRenew =>
      (super.noSuchMethod(Invocation.getter(#willRenew), returnValue: false)
          as bool);

  @override
  String get latestPurchaseDate => (super.noSuchMethod(
        Invocation.getter(#latestPurchaseDate),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#latestPurchaseDate),
        ),
      ) as String);

  @override
  String get originalPurchaseDate => (super.noSuchMethod(
        Invocation.getter(#originalPurchaseDate),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#originalPurchaseDate),
        ),
      ) as String);

  @override
  String get productIdentifier => (super.noSuchMethod(
        Invocation.getter(#productIdentifier),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#productIdentifier),
        ),
      ) as String);

  @override
  bool get isSandbox =>
      (super.noSuchMethod(Invocation.getter(#isSandbox), returnValue: false)
          as bool);

  @override
  _i5.OwnershipType get ownershipType => (super.noSuchMethod(
        Invocation.getter(#ownershipType),
        returnValue: _i5.OwnershipType.purchased,
      ) as _i5.OwnershipType);

  @override
  _i15.Store get store => (super.noSuchMethod(
        Invocation.getter(#store),
        returnValue: _i15.Store.appStore,
      ) as _i15.Store);

  @override
  _i5.PeriodType get periodType => (super.noSuchMethod(
        Invocation.getter(#periodType),
        returnValue: _i5.PeriodType.intro,
      ) as _i5.PeriodType);

  @override
  _i16.VerificationResult get verification => (super.noSuchMethod(
        Invocation.getter(#verification),
        returnValue: _i16.VerificationResult.notRequested,
      ) as _i16.VerificationResult);

  @override
  _i5.$EntitlementInfoCopyWith<_i5.EntitlementInfo> get copyWith =>
      (super.noSuchMethod(
        Invocation.getter(#copyWith),
        returnValue: _Fake$EntitlementInfoCopyWith_4<_i5.EntitlementInfo>(
          this,
          Invocation.getter(#copyWith),
        ),
      ) as _i5.$EntitlementInfoCopyWith<_i5.EntitlementInfo>);

  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(#toJson, []),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
}

/// A class which mocks [EntitlementInfos].
///
/// See the documentation for Mockito's code generation for more information.
class MockEntitlementInfos extends _i1.Mock implements _i3.EntitlementInfos {
  MockEntitlementInfos() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, _i5.EntitlementInfo> get all => (super.noSuchMethod(
        Invocation.getter(#all),
        returnValue: <String, _i5.EntitlementInfo>{},
      ) as Map<String, _i5.EntitlementInfo>);

  @override
  Map<String, _i5.EntitlementInfo> get active => (super.noSuchMethod(
        Invocation.getter(#active),
        returnValue: <String, _i5.EntitlementInfo>{},
      ) as Map<String, _i5.EntitlementInfo>);

  @override
  _i16.VerificationResult get verification => (super.noSuchMethod(
        Invocation.getter(#verification),
        returnValue: _i16.VerificationResult.notRequested,
      ) as _i16.VerificationResult);

  @override
  _i3.$EntitlementInfosCopyWith<_i3.EntitlementInfos> get copyWith =>
      (super.noSuchMethod(
        Invocation.getter(#copyWith),
        returnValue: _Fake$EntitlementInfosCopyWith_5<_i3.EntitlementInfos>(
          this,
          Invocation.getter(#copyWith),
        ),
      ) as _i3.$EntitlementInfosCopyWith<_i3.EntitlementInfos>);

  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(#toJson, []),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
}

/// A class which mocks [IoWrapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockIoWrapper extends _i1.Mock implements _i17.IoWrapper {
  MockIoWrapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isAndroid =>
      (super.noSuchMethod(Invocation.getter(#isAndroid), returnValue: false)
          as bool);

  @override
  bool get isIOS =>
      (super.noSuchMethod(Invocation.getter(#isIOS), returnValue: false)
          as bool);

  @override
  _i13.Future<List<_i18.InternetAddress>> lookup(String? host) =>
      (super.noSuchMethod(
        Invocation.method(#lookup, [host]),
        returnValue: _i13.Future<List<_i18.InternetAddress>>.value(
          <_i18.InternetAddress>[],
        ),
      ) as _i13.Future<List<_i18.InternetAddress>>);
}

/// A class which mocks [IntroductoryPrice].
///
/// See the documentation for Mockito's code generation for more information.
class MockIntroductoryPrice extends _i1.Mock implements _i4.IntroductoryPrice {
  MockIntroductoryPrice() {
    _i1.throwOnMissingStub(this);
  }

  @override
  double get price =>
      (super.noSuchMethod(Invocation.getter(#price), returnValue: 0.0)
          as double);

  @override
  String get priceString => (super.noSuchMethod(
        Invocation.getter(#priceString),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#priceString),
        ),
      ) as String);

  @override
  String get period => (super.noSuchMethod(
        Invocation.getter(#period),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#period),
        ),
      ) as String);

  @override
  int get cycles =>
      (super.noSuchMethod(Invocation.getter(#cycles), returnValue: 0) as int);

  @override
  _i19.PeriodUnit get periodUnit => (super.noSuchMethod(
        Invocation.getter(#periodUnit),
        returnValue: _i19.PeriodUnit.day,
      ) as _i19.PeriodUnit);

  @override
  int get periodNumberOfUnits => (super.noSuchMethod(
        Invocation.getter(#periodNumberOfUnits),
        returnValue: 0,
      ) as int);

  @override
  _i4.$IntroductoryPriceCopyWith<_i4.IntroductoryPrice> get copyWith =>
      (super.noSuchMethod(
        Invocation.getter(#copyWith),
        returnValue: _Fake$IntroductoryPriceCopyWith_6<_i4.IntroductoryPrice>(
          this,
          Invocation.getter(#copyWith),
        ),
      ) as _i4.$IntroductoryPriceCopyWith<_i4.IntroductoryPrice>);

  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(#toJson, []),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
}

/// A class which mocks [LogInResult].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogInResult extends _i1.Mock implements _i6.LogInResult {
  MockLogInResult() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get created =>
      (super.noSuchMethod(Invocation.getter(#created), returnValue: false)
          as bool);

  @override
  _i4.CustomerInfo get customerInfo => (super.noSuchMethod(
        Invocation.getter(#customerInfo),
        returnValue: _FakeCustomerInfo_7(
          this,
          Invocation.getter(#customerInfo),
        ),
      ) as _i4.CustomerInfo);
}

/// A class which mocks [NativeTimeZoneWrapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockNativeTimeZoneWrapper extends _i1.Mock
    implements _i20.NativeTimeZoneWrapper {
  MockNativeTimeZoneWrapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i13.Future<List<String>> getAvailableTimeZones() => (super.noSuchMethod(
        Invocation.method(#getAvailableTimeZones, []),
        returnValue: _i13.Future<List<String>>.value(<String>[]),
      ) as _i13.Future<List<String>>);

  @override
  _i13.Future<String> getLocalTimeZone() => (super.noSuchMethod(
        Invocation.method(#getLocalTimeZone, []),
        returnValue: _i13.Future<String>.value(
          _i11.dummyValue<String>(
            this,
            Invocation.method(#getLocalTimeZone, []),
          ),
        ),
      ) as _i13.Future<String>);
}

/// A class which mocks [Offering].
///
/// See the documentation for Mockito's code generation for more information.
class MockOffering extends _i1.Mock implements _i4.Offering {
  MockOffering() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get identifier => (super.noSuchMethod(
        Invocation.getter(#identifier),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#identifier),
        ),
      ) as String);

  @override
  String get serverDescription => (super.noSuchMethod(
        Invocation.getter(#serverDescription),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#serverDescription),
        ),
      ) as String);

  @override
  Map<String, Object> get metadata => (super.noSuchMethod(
        Invocation.getter(#metadata),
        returnValue: <String, Object>{},
      ) as Map<String, Object>);

  @override
  List<_i4.Package> get availablePackages => (super.noSuchMethod(
        Invocation.getter(#availablePackages),
        returnValue: <_i4.Package>[],
      ) as List<_i4.Package>);

  @override
  _i4.$OfferingCopyWith<_i4.Offering> get copyWith => (super.noSuchMethod(
        Invocation.getter(#copyWith),
        returnValue: _Fake$OfferingCopyWith_8<_i4.Offering>(
          this,
          Invocation.getter(#copyWith),
        ),
      ) as _i4.$OfferingCopyWith<_i4.Offering>);

  @override
  _i4.Package? getPackage(String? identifier) =>
      (super.noSuchMethod(Invocation.method(#getPackage, [identifier]))
          as _i4.Package?);

  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(#toJson, []),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
}

/// A class which mocks [Offerings].
///
/// See the documentation for Mockito's code generation for more information.
class MockOfferings extends _i1.Mock implements _i4.Offerings {
  MockOfferings() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, _i4.Offering> get all => (super.noSuchMethod(
        Invocation.getter(#all),
        returnValue: <String, _i4.Offering>{},
      ) as Map<String, _i4.Offering>);

  @override
  _i4.$OfferingsCopyWith<_i4.Offerings> get copyWith => (super.noSuchMethod(
        Invocation.getter(#copyWith),
        returnValue: _Fake$OfferingsCopyWith_9<_i4.Offerings>(
          this,
          Invocation.getter(#copyWith),
        ),
      ) as _i4.$OfferingsCopyWith<_i4.Offerings>);

  @override
  _i4.Offering? getOffering(String? identifier) =>
      (super.noSuchMethod(Invocation.method(#getOffering, [identifier]))
          as _i4.Offering?);

  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(#toJson, []),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
}

/// A class which mocks [Package].
///
/// See the documentation for Mockito's code generation for more information.
class MockPackage extends _i1.Mock implements _i4.Package {
  MockPackage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get identifier => (super.noSuchMethod(
        Invocation.getter(#identifier),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#identifier),
        ),
      ) as String);

  @override
  _i4.PackageType get packageType => (super.noSuchMethod(
        Invocation.getter(#packageType),
        returnValue: _i4.PackageType.unknown,
      ) as _i4.PackageType);

  @override
  _i4.StoreProduct get storeProduct => (super.noSuchMethod(
        Invocation.getter(#storeProduct),
        returnValue: _FakeStoreProduct_10(
          this,
          Invocation.getter(#storeProduct),
        ),
      ) as _i4.StoreProduct);

  @override
  _i4.PresentedOfferingContext get presentedOfferingContext =>
      (super.noSuchMethod(
        Invocation.getter(#presentedOfferingContext),
        returnValue: _FakePresentedOfferingContext_11(
          this,
          Invocation.getter(#presentedOfferingContext),
        ),
      ) as _i4.PresentedOfferingContext);

  @override
  _i4.$PackageCopyWith<_i4.Package> get copyWith => (super.noSuchMethod(
        Invocation.getter(#copyWith),
        returnValue: _Fake$PackageCopyWith_12<_i4.Package>(
          this,
          Invocation.getter(#copyWith),
        ),
      ) as _i4.$PackageCopyWith<_i4.Package>);

  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(#toJson, []),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
}

/// A class which mocks [PlatformException].
///
/// See the documentation for Mockito's code generation for more information.
class MockPlatformException extends _i1.Mock implements _i21.PlatformException {
  MockPlatformException() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get code => (super.noSuchMethod(
        Invocation.getter(#code),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#code),
        ),
      ) as String);
}

/// A class which mocks [PropertiesManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockPropertiesManager extends _i1.Mock implements _i22.PropertiesManager {
  MockPropertiesManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get clientSenderEmail => (super.noSuchMethod(
        Invocation.getter(#clientSenderEmail),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#clientSenderEmail),
        ),
      ) as String);

  @override
  String get revenueCatApiKey => (super.noSuchMethod(
        Invocation.getter(#revenueCatApiKey),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#revenueCatApiKey),
        ),
      ) as String);

  @override
  String get revenueCatGoogleApiKey => (super.noSuchMethod(
        Invocation.getter(#revenueCatGoogleApiKey),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#revenueCatGoogleApiKey),
        ),
      ) as String);

  @override
  String get revenueCatAppleApiKey => (super.noSuchMethod(
        Invocation.getter(#revenueCatAppleApiKey),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#revenueCatAppleApiKey),
        ),
      ) as String);

  @override
  String get supportEmail => (super.noSuchMethod(
        Invocation.getter(#supportEmail),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#supportEmail),
        ),
      ) as String);

  @override
  String get sendGridApiKey => (super.noSuchMethod(
        Invocation.getter(#sendGridApiKey),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#sendGridApiKey),
        ),
      ) as String);

  @override
  String get feedbackTemplate => (super.noSuchMethod(
        Invocation.getter(#feedbackTemplate),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#feedbackTemplate),
        ),
      ) as String);

  @override
  _i13.Future<void> init() => (super.noSuchMethod(
        Invocation.method(#init, []),
        returnValue: _i13.Future<void>.value(),
        returnValueForMissingStub: _i13.Future<void>.value(),
      ) as _i13.Future<void>);
}

/// A class which mocks [PurchasesWrapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockPurchasesWrapper extends _i1.Mock implements _i23.PurchasesWrapper {
  MockPurchasesWrapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i13.Future<bool> get isAnonymous => (super.noSuchMethod(
        Invocation.getter(#isAnonymous),
        returnValue: _i13.Future<bool>.value(false),
      ) as _i13.Future<bool>);

  @override
  void addCustomerInfoUpdateListener(
    dynamic Function(_i4.CustomerInfo)? listener,
  ) =>
      super.noSuchMethod(
        Invocation.method(#addCustomerInfoUpdateListener, [listener]),
        returnValueForMissingStub: null,
      );

  @override
  _i13.Future<void> configure(String? apiKey) => (super.noSuchMethod(
        Invocation.method(#configure, [apiKey]),
        returnValue: _i13.Future<void>.value(),
        returnValueForMissingStub: _i13.Future<void>.value(),
      ) as _i13.Future<void>);

  @override
  void setLogLevel(_i6.LogLevel? level) => super.noSuchMethod(
        Invocation.method(#setLogLevel, [level]),
        returnValueForMissingStub: null,
      );

  @override
  _i13.Future<_i4.Offerings> getOfferings() => (super.noSuchMethod(
        Invocation.method(#getOfferings, []),
        returnValue: _i13.Future<_i4.Offerings>.value(
          _FakeOfferings_13(this, Invocation.method(#getOfferings, [])),
        ),
      ) as _i13.Future<_i4.Offerings>);

  @override
  _i13.Future<_i4.CustomerInfo> getCustomerInfo() => (super.noSuchMethod(
        Invocation.method(#getCustomerInfo, []),
        returnValue: _i13.Future<_i4.CustomerInfo>.value(
          _FakeCustomerInfo_7(
            this,
            Invocation.method(#getCustomerInfo, []),
          ),
        ),
      ) as _i13.Future<_i4.CustomerInfo>);

  @override
  _i13.Future<_i6.LogInResult> logIn(String? appUserId) => (super.noSuchMethod(
        Invocation.method(#logIn, [appUserId]),
        returnValue: _i13.Future<_i6.LogInResult>.value(
          _FakeLogInResult_14(this, Invocation.method(#logIn, [appUserId])),
        ),
      ) as _i13.Future<_i6.LogInResult>);

  @override
  _i13.Future<_i4.CustomerInfo> purchasePackage(_i4.Package? package) =>
      (super.noSuchMethod(
        Invocation.method(#purchasePackage, [package]),
        returnValue: _i13.Future<_i4.CustomerInfo>.value(
          _FakeCustomerInfo_7(
            this,
            Invocation.method(#purchasePackage, [package]),
          ),
        ),
      ) as _i13.Future<_i4.CustomerInfo>);

  @override
  _i13.Future<_i4.CustomerInfo> logOut() => (super.noSuchMethod(
        Invocation.method(#logOut, []),
        returnValue: _i13.Future<_i4.CustomerInfo>.value(
          _FakeCustomerInfo_7(this, Invocation.method(#logOut, [])),
        ),
      ) as _i13.Future<_i4.CustomerInfo>);

  @override
  _i13.Future<_i4.CustomerInfo> restorePurchases() => (super.noSuchMethod(
        Invocation.method(#restorePurchases, []),
        returnValue: _i13.Future<_i4.CustomerInfo>.value(
          _FakeCustomerInfo_7(
            this,
            Invocation.method(#restorePurchases, []),
          ),
        ),
      ) as _i13.Future<_i4.CustomerInfo>);
}

/// A class which mocks [StoreProduct].
///
/// See the documentation for Mockito's code generation for more information.
class MockStoreProduct extends _i1.Mock implements _i4.StoreProduct {
  MockStoreProduct() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get identifier => (super.noSuchMethod(
        Invocation.getter(#identifier),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#identifier),
        ),
      ) as String);

  @override
  String get description => (super.noSuchMethod(
        Invocation.getter(#description),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#description),
        ),
      ) as String);

  @override
  String get title => (super.noSuchMethod(
        Invocation.getter(#title),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#title),
        ),
      ) as String);

  @override
  double get price =>
      (super.noSuchMethod(Invocation.getter(#price), returnValue: 0.0)
          as double);

  @override
  String get priceString => (super.noSuchMethod(
        Invocation.getter(#priceString),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#priceString),
        ),
      ) as String);

  @override
  String get currencyCode => (super.noSuchMethod(
        Invocation.getter(#currencyCode),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#currencyCode),
        ),
      ) as String);

  @override
  _i4.$StoreProductCopyWith<_i4.StoreProduct> get copyWith =>
      (super.noSuchMethod(
        Invocation.getter(#copyWith),
        returnValue: _Fake$StoreProductCopyWith_15<_i4.StoreProduct>(
          this,
          Invocation.getter(#copyWith),
        ),
      ) as _i4.$StoreProductCopyWith<_i4.StoreProduct>);

  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(#toJson, []),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
}

/// A class which mocks [SubscriptionManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockSubscriptionManager extends _i1.Mock
    implements _i24.SubscriptionManager {
  MockSubscriptionManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isFree =>
      (super.noSuchMethod(Invocation.getter(#isFree), returnValue: false)
          as bool);

  @override
  bool get isPro =>
      (super.noSuchMethod(Invocation.getter(#isPro), returnValue: false)
          as bool);

  @override
  _i13.Stream<void> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i13.Stream<void>.empty(),
      ) as _i13.Stream<void>);

  @override
  _i13.Future<String> get userId => (super.noSuchMethod(
        Invocation.getter(#userId),
        returnValue: _i13.Future<String>.value(
          _i11.dummyValue<String>(this, Invocation.getter(#userId)),
        ),
      ) as _i13.Future<String>);

  @override
  _i13.Future<void> init() => (super.noSuchMethod(
        Invocation.method(#init, []),
        returnValue: _i13.Future<void>.value(),
        returnValueForMissingStub: _i13.Future<void>.value(),
      ) as _i13.Future<void>);

  @override
  _i13.Future<void> purchaseSubscription(_i24.Subscription? sub) =>
      (super.noSuchMethod(
        Invocation.method(#purchaseSubscription, [sub]),
        returnValue: _i13.Future<void>.value(),
        returnValueForMissingStub: _i13.Future<void>.value(),
      ) as _i13.Future<void>);

  @override
  _i13.Future<_i24.RestoreSubscriptionResult> restoreSubscription() =>
      (super.noSuchMethod(
        Invocation.method(#restoreSubscription, []),
        returnValue: _i13.Future<_i24.RestoreSubscriptionResult>.value(
          _i24.RestoreSubscriptionResult.noSubscriptionsFound,
        ),
      ) as _i13.Future<_i24.RestoreSubscriptionResult>);

  @override
  _i13.Future<_i24.Subscriptions?> subscriptions() => (super.noSuchMethod(
        Invocation.method(#subscriptions, []),
        returnValue: _i13.Future<_i24.Subscriptions?>.value(),
      ) as _i13.Future<_i24.Subscriptions?>);
}

/// A class which mocks [TimeManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockTimeManager extends _i1.Mock implements _i8.TimeManager {
  MockTimeManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.TZDateTime get currentDateTime => (super.noSuchMethod(
        Invocation.getter(#currentDateTime),
        returnValue: _FakeTZDateTime_16(
          this,
          Invocation.getter(#currentDateTime),
        ),
      ) as _i7.TZDateTime);

  @override
  _i8.TimeZoneLocation get currentLocation => (super.noSuchMethod(
        Invocation.getter(#currentLocation),
        returnValue: _FakeTimeZoneLocation_17(
          this,
          Invocation.getter(#currentLocation),
        ),
      ) as _i8.TimeZoneLocation);

  @override
  _i2.TimeOfDay get currentTime => (super.noSuchMethod(
        Invocation.getter(#currentTime),
        returnValue: _FakeTimeOfDay_18(
          this,
          Invocation.getter(#currentTime),
        ),
      ) as _i2.TimeOfDay);

  @override
  int get currentTimestamp =>
      (super.noSuchMethod(Invocation.getter(#currentTimestamp), returnValue: 0)
          as int);

  @override
  String get currentTimeZone => (super.noSuchMethod(
        Invocation.getter(#currentTimeZone),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#currentTimeZone),
        ),
      ) as String);

  @override
  _i13.Future<void> init() => (super.noSuchMethod(
        Invocation.method(#init, []),
        returnValue: _i13.Future<void>.value(),
        returnValueForMissingStub: _i13.Future<void>.value(),
      ) as _i13.Future<void>);

  @override
  List<_i8.TimeZoneLocation> filteredLocations(
    String? query, {
    _i8.TimeZoneLocation? exclude,
  }) =>
      (super.noSuchMethod(
        Invocation.method(#filteredLocations, [query], {#exclude: exclude}),
        returnValue: <_i8.TimeZoneLocation>[],
      ) as List<_i8.TimeZoneLocation>);

  @override
  _i7.TZDateTime dateTime(int? timestamp, [String? timeZone]) =>
      (super.noSuchMethod(
        Invocation.method(#dateTime, [timestamp, timeZone]),
        returnValue: _FakeTZDateTime_16(
          this,
          Invocation.method(#dateTime, [timestamp, timeZone]),
        ),
      ) as _i7.TZDateTime);

  @override
  _i7.TZDateTime dateTimeFromSeconds(
    int? timestampSeconds, [
    String? timeZone,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(#dateTimeFromSeconds, [
          timestampSeconds,
          timeZone,
        ]),
        returnValue: _FakeTZDateTime_16(
          this,
          Invocation.method(#dateTimeFromSeconds, [
            timestampSeconds,
            timeZone,
          ]),
        ),
      ) as _i7.TZDateTime);

  @override
  _i7.TZDateTime dateTimeFromValues(
    int? year, [
    int? month = 1,
    int? day = 1,
    int? hour = 0,
    int? minute = 0,
    int? second = 0,
    int? millisecond = 0,
    int? microsecond = 0,
    String? timeZone,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(#dateTimeFromValues, [
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
          timeZone,
        ]),
        returnValue: _FakeTZDateTime_16(
          this,
          Invocation.method(#dateTimeFromValues, [
            year,
            month,
            day,
            hour,
            minute,
            second,
            millisecond,
            microsecond,
            timeZone,
          ]),
        ),
      ) as _i7.TZDateTime);

  @override
  _i7.TZDateTime dateTimeToTz(DateTime? dateTime) => (super.noSuchMethod(
        Invocation.method(#dateTimeToTz, [dateTime]),
        returnValue: _FakeTZDateTime_16(
          this,
          Invocation.method(#dateTimeToTz, [dateTime]),
        ),
      ) as _i7.TZDateTime);

  @override
  _i7.TZDateTime now([String? timeZone]) => (super.noSuchMethod(
        Invocation.method(#now, [timeZone]),
        returnValue: _FakeTZDateTime_16(
          this,
          Invocation.method(#now, [timeZone]),
        ),
      ) as _i7.TZDateTime);
}
