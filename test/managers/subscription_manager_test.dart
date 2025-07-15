import 'package:adair_flutter_lib/managers/subscription_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();

    when(managers.ioWrapper.isAndroid).thenReturn(false);

    when(managers.propertiesManager.revenueCatAppleApiKey).thenReturn("");

    when(
      managers.purchasesWrapper.configure(any),
    ).thenAnswer((_) => Future.value());
    when(managers.purchasesWrapper.setLogLevel(any)).thenAnswer((_) {});
    when(
      managers.purchasesWrapper.addCustomerInfoUpdateListener(any),
    ).thenAnswer((_) {});
    when(
      managers.purchasesWrapper.logIn(any),
    ).thenAnswer((_) => Future.value(MockLogInResult()));
    when(
      managers.purchasesWrapper.logOut(),
    ).thenAnswer((_) => Future.value(MockCustomerInfo()));

    SubscriptionManager.reset();
  });

  MockCustomerInfo stubbedCustomerInfo() {
    var entitlementInfo = MockEntitlementInfo();
    when(entitlementInfo.isActive).thenReturn(true);

    var entitlementInfos = MockEntitlementInfos();
    when(entitlementInfos.all).thenReturn({"pro": entitlementInfo});

    var customerInfo = MockCustomerInfo();
    when(customerInfo.entitlements).thenReturn(entitlementInfos);
    when(customerInfo.originalAppUserId).thenReturn("user-id");

    return customerInfo;
  }

  test("Initialize for Android", () async {
    when(
      managers.purchasesWrapper.getCustomerInfo(),
    ).thenAnswer((_) => Future.value(stubbedCustomerInfo()));
    when(managers.ioWrapper.isAndroid).thenReturn(true);
    when(managers.propertiesManager.revenueCatGoogleApiKey).thenReturn("G");

    await SubscriptionManager.get.init();
    verify(managers.propertiesManager.revenueCatGoogleApiKey).called(1);
    verifyNever(managers.propertiesManager.revenueCatAppleApiKey);
  });

  test("Initialize for iOS", () async {
    when(
      managers.purchasesWrapper.getCustomerInfo(),
    ).thenAnswer((_) => Future.value(stubbedCustomerInfo()));
    when(managers.ioWrapper.isAndroid).thenReturn(false);
    when(managers.propertiesManager.revenueCatAppleApiKey).thenReturn("A");

    await SubscriptionManager.get.init();
    verify(managers.propertiesManager.revenueCatAppleApiKey).called(1);
    verifyNever(managers.propertiesManager.revenueCatGoogleApiKey);
  });

  test("Initialize ignores network error", () async {
    var exception = MockPlatformException();
    when(
      exception.code,
    ).thenReturn(PurchasesErrorCode.networkError.index.toString());
    when(
      managers.purchasesWrapper.getCustomerInfo(),
    ).thenAnswer((_) => throw exception);
    await SubscriptionManager.get.init();
    verifyNever(exception.message);
  });

  test("Initialize ignores offline error", () async {
    var exception = MockPlatformException();
    when(
      exception.code,
    ).thenReturn(PurchasesErrorCode.offlineConnectionError.index.toString());
    when(
      managers.purchasesWrapper.getCustomerInfo(),
    ).thenAnswer((_) => throw exception);
    await SubscriptionManager.get.init();
    verifyNever(exception.message);
  });

  test("Initialize ignores user account error", () async {
    var exception = MockPlatformException();
    when(
      exception.code,
    ).thenReturn(PurchasesErrorCode.purchaseNotAllowedError.index.toString());
    when(
      managers.purchasesWrapper.getCustomerInfo(),
    ).thenAnswer((_) => throw exception);
    await SubscriptionManager.get.init();
    verifyNever(exception.message);
  });

  test("Initialize ignores receipt in use error", () async {
    var exception = MockPlatformException();
    when(
      exception.code,
    ).thenReturn(PurchasesErrorCode.receiptAlreadyInUseError.index.toString());
    when(
      managers.purchasesWrapper.getCustomerInfo(),
    ).thenAnswer((_) => throw exception);
    await SubscriptionManager.get.init();
    verifyNever(exception.message);
  });

  test("Initialize logs error", () async {
    var exception = MockPlatformException();
    when(
      exception.code,
    ).thenReturn(PurchasesErrorCode.apiEndpointBlocked.index.toString());
    when(exception.message).thenReturn("Test");
    when(
      managers.purchasesWrapper.getCustomerInfo(),
    ).thenAnswer((_) => throw exception);
    await SubscriptionManager.get.init();
    verify(exception.message).called(1);
  });

  test("Successful restore error sets state to pro", () async {
    when(
      managers.purchasesWrapper.restorePurchases(),
    ).thenAnswer((_) => Future.value(stubbedCustomerInfo()));

    var restoreResult = await SubscriptionManager.get.restoreSubscription();
    expect(restoreResult, RestoreSubscriptionResult.success);
    expect(SubscriptionManager.get.isPro, isTrue);
  });

  test("Restore error sets state to free", () async {
    when(
      managers.purchasesWrapper.restorePurchases(),
    ).thenThrow(PlatformException(code: "0"));

    var restoreResult = await SubscriptionManager.get.restoreSubscription();
    expect(restoreResult, RestoreSubscriptionResult.error);
    expect(SubscriptionManager.get.isFree, isTrue);
  });

  test("Restore no subs found sets state to free", () async {
    var entitlementInfo = MockEntitlementInfo();
    when(entitlementInfo.isActive).thenReturn(false);

    var entitlementInfos = MockEntitlementInfos();
    when(entitlementInfos.all).thenReturn({"pro": entitlementInfo});

    var purchaserInfo = MockCustomerInfo();
    when(purchaserInfo.entitlements).thenReturn(entitlementInfos);

    when(
      managers.purchasesWrapper.restorePurchases(),
    ).thenAnswer((_) => Future.value(purchaserInfo));

    var restoreResult = await SubscriptionManager.get.restoreSubscription();
    expect(restoreResult, RestoreSubscriptionResult.noSubscriptionsFound);
    expect(SubscriptionManager.get.isFree, isTrue);
  });

  test("No current RevenueCat offering returns null", () async {
    var offerings = MockOfferings();
    when(offerings.current).thenReturn(null);

    when(
      managers.purchasesWrapper.getOfferings(),
    ).thenAnswer((_) => Future.value(offerings));
    expect(await SubscriptionManager.get.subscriptions(), isNull);
  });

  test("No available RevenueCat packages returns null", () async {
    var offering = MockOffering();
    when(offering.monthly).thenReturn(MockPackage());
    when(offering.annual).thenReturn(MockPackage());
    when(offering.availablePackages).thenReturn([]);

    var offerings = MockOfferings();
    when(offerings.current).thenReturn(offering);

    when(
      managers.purchasesWrapper.getOfferings(),
    ).thenAnswer((_) => Future.value(offerings));

    expect(await SubscriptionManager.get.subscriptions(), isNull);
  });

  test("Fetch subscriptions returns Subscriptions object", () async {
    var offering = MockOffering();
    when(offering.monthly).thenReturn(MockPackage());
    when(offering.annual).thenReturn(MockPackage());
    when(offering.availablePackages).thenReturn([MockPackage()]);

    var offerings = MockOfferings();
    when(offerings.current).thenReturn(offering);

    when(
      managers.purchasesWrapper.getOfferings(),
    ).thenAnswer((_) => Future.value(offerings));

    expect(await SubscriptionManager.get.subscriptions(), isNotNull);
  });

  test("Listeners are notified on state changes", () async {
    var entitlementInfo = MockEntitlementInfo();
    when(entitlementInfo.isActive).thenReturn(true);

    var entitlementInfos = MockEntitlementInfos();
    when(entitlementInfos.all).thenReturn({"pro": entitlementInfo});

    var purchaserInfo = MockCustomerInfo();
    when(purchaserInfo.entitlements).thenReturn(entitlementInfos);

    when(
      managers.purchasesWrapper.restorePurchases(),
    ).thenAnswer((_) => Future.value(purchaserInfo));

    var called = false;
    var listener = SubscriptionManager.get.stream.listen((_) => called = true);

    var restoreResult = await SubscriptionManager.get.restoreSubscription();
    expect(restoreResult, RestoreSubscriptionResult.success);
    expect(SubscriptionManager.get.isPro, isTrue);

    await Future.delayed(const Duration(milliseconds: 50));
    expect(called, isTrue);

    listener.cancel();
  });

  test("Subscription trial length days returns null", () {
    var product = MockStoreProduct();
    when(product.introductoryPrice).thenReturn(null);

    var package = MockPackage();
    when(package.storeProduct).thenReturn(product);

    var sub = Subscription(package);
    expect(sub.trialLengthDays, null);
  });

  test("Subscription trial length days returns correct result", () {
    var price = MockIntroductoryPrice();
    when(price.periodUnit).thenReturn(PeriodUnit.month);
    when(price.periodNumberOfUnits).thenReturn(2);

    var product = MockStoreProduct();
    when(product.introductoryPrice).thenReturn(price);

    var package = MockPackage();
    when(package.storeProduct).thenReturn(product);

    var sub = Subscription(package);
    expect(sub.trialLengthDays, 60);

    when(price.periodUnit).thenReturn(PeriodUnit.day);
    when(price.periodNumberOfUnits).thenReturn(15);
    expect(sub.trialLengthDays, 15);

    when(price.periodUnit).thenReturn(PeriodUnit.week);
    when(price.periodNumberOfUnits).thenReturn(1);
    expect(sub.trialLengthDays, 7);

    when(price.periodUnit).thenReturn(PeriodUnit.year);
    when(price.periodNumberOfUnits).thenReturn(1);
    expect(sub.trialLengthDays, 365);

    when(price.periodUnit).thenReturn(PeriodUnit.unknown);
    when(price.periodNumberOfUnits).thenReturn(1);
    expect(sub.trialLengthDays, 0);
  });
}
