import 'package:adair_flutter_lib/managers/subscription_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:purchases_flutter/errors.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() {
    managers = StubbedManagers();
    when(managers.propertiesManager.revenueCatApiKey).thenReturn("");

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
    var entitlementInfo = MockEntitlementInfo();
    when(entitlementInfo.isActive).thenReturn(true);

    var entitlementInfos = MockEntitlementInfos();
    when(entitlementInfos.all).thenReturn({"pro": entitlementInfo});

    var purchaserInfo = MockCustomerInfo();
    when(purchaserInfo.entitlements).thenReturn(entitlementInfos);

    when(
      managers.purchasesWrapper.restorePurchases(),
    ).thenAnswer((_) => Future.value(purchaserInfo));

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
}
