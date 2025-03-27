import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../utils/log.dart';
import '../utils/void_stream_controller.dart';
import '../wrappers/crashlytics_wrapper.dart';
import '../wrappers/purchases_wrapper.dart';
import 'properties_manager.dart';

enum SubscriptionState { pro, free }

enum RestoreSubscriptionResult { noSubscriptionsFound, error, success }

/// Manages a user's subscription state. A middleman between the app and the
/// RevenueCat SDK.
///
/// Sandbox testing notes:
/// - iOS subscriptions will auto-review five times before becoming inactive.
///   There's nothing to do here but wait. For wait times, see
///   https://help.apple.com/app-store-connect/#/dev7e89e149d.
class SubscriptionManager {
  static var _instance = SubscriptionManager._();

  static SubscriptionManager get get => _instance;

  @visibleForTesting
  static void set(SubscriptionManager manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = SubscriptionManager._();

  SubscriptionManager._();

  static const _debugPurchases = true;
  static const _idProEntitlement = "pro";

  static const _trialDaysYearly = 30;
  static const _trialDaysMonthly = 7;

  final _log = const Log("SubscriptionManager");
  final _controller = VoidStreamController();

  var _state = SubscriptionState.free;

  bool get isFree => _state == SubscriptionState.free;

  bool get isPro => _state == SubscriptionState.pro;

  /// A [Stream] that fires events when [state] updates. Listeners should
  /// access the [state] property directly, as it will always have a valid
  /// value, unlike the [AsyncSnapshot] passed to the listener function.
  Stream<void> get stream => _controller.stream;

  Future<String> get userId async =>
      (await PurchasesWrapper.get.getCustomerInfo()).originalAppUserId;

  Future<void> init() async {
    // Setup RevenueCat.
    await PurchasesWrapper.get.configure(
      PropertiesManager.get.revenueCatApiKey,
    );
    PurchasesWrapper.get.setLogLevel(
      _debugPurchases ? LogLevel.verbose : LogLevel.error,
    );

    // Setup purchase state listener and initial state.
    PurchasesWrapper.get.addCustomerInfoUpdateListener(
      _setStateFromPurchaserInfo,
    );

    // Set current state.
    try {
      var customerInfo = await PurchasesWrapper.get.getCustomerInfo();
      CrashlyticsWrapper.get.setUserId(customerInfo.originalAppUserId);
      _setStateFromPurchaserInfo(customerInfo);
    } on PlatformException catch (e) {
      var code = PurchasesErrorHelper.getErrorCode(e);

      // Don't log network or user account errors since they'll likely fix
      // themselves on next startup.
      if (code == PurchasesErrorCode.networkError ||
          code == PurchasesErrorCode.offlineConnectionError ||
          code == PurchasesErrorCode.purchaseNotAllowedError ||
          // Can happen on app re-install; user needs to restore purchase.
          code == PurchasesErrorCode.receiptAlreadyInUseError) {
        return;
      }
      _log.e(StackTrace.current, "Purchase info error: ${e.message}");
    }
  }

  Future<void> purchaseSubscription(Subscription sub) async {
    // Note that this method doesn't return an error or result object because
    // purchase errors are shown by the underlying storefront UI.
    try {
      _setStateFromPurchaserInfo(
        await PurchasesWrapper.get.purchasePackage(sub.package),
      );
    } on PlatformException catch (e) {
      var code = PurchasesErrorHelper.getErrorCode(e);
      if (code != PurchasesErrorCode.purchaseCancelledError &&
          code != PurchasesErrorCode.storeProblemError) {
        _log.e(StackTrace.current, "Purchase error: ${e.message}");
      }
    }
  }

  Future<RestoreSubscriptionResult> restoreSubscription() async {
    try {
      _setStateFromPurchaserInfo(await PurchasesWrapper.get.restorePurchases());
      return isFree
          ? RestoreSubscriptionResult.noSubscriptionsFound
          : RestoreSubscriptionResult.success;
    } on PlatformException catch (e) {
      _log.e(StackTrace.current, "Purchase restore error: ${e.message}");
      return RestoreSubscriptionResult.error;
    }
  }

  Future<Subscriptions?> subscriptions() async {
    var offerings = await PurchasesWrapper.get.getOfferings();

    if (offerings.current == null) {
      _log.e(StackTrace.current, "Current offering is null");
      return null;
    }

    if (offerings.current!.availablePackages.isEmpty) {
      _log.e(StackTrace.current, "Current offering has no available packages");
      return null;
    }

    return Subscriptions(
      Subscription(offerings.current!.monthly!, _trialDaysMonthly),
      Subscription(offerings.current!.annual!, _trialDaysYearly),
    );
  }

  void _setState(SubscriptionState state) {
    if (_state == state) {
      return;
    }
    _log.d("Updated state: $state");
    _state = state;
    _controller.notify();
  }

  void _setStateFromPurchaserInfo(CustomerInfo customerInfo) {
    _setState(
      customerInfo.entitlements.all[_idProEntitlement]?.isActive ?? false
          ? SubscriptionState.pro
          : SubscriptionState.free,
    );
  }
}

class Subscription {
  final Package package;
  final int trialLengthDays;

  Subscription(this.package, this.trialLengthDays);

  String get price => package.storeProduct.priceString;
}

/// A convenience class that stores subscription options. A single class like
/// this is easier to manage than a collection of subscriptions, especially
/// when the options shouldn't change.
class Subscriptions {
  final Subscription monthly;
  final Subscription yearly;

  Subscriptions(this.monthly, this.yearly);
}
