import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesWrapper {
  static var _instance = PurchasesWrapper._();

  static PurchasesWrapper get get => _instance;

  @visibleForTesting
  static void set(PurchasesWrapper manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = PurchasesWrapper._();

  PurchasesWrapper._();

  void addCustomerInfoUpdateListener(Function(CustomerInfo) listener) =>
      Purchases.addCustomerInfoUpdateListener(listener);

  Future<void> configure(String apiKey) =>
      Purchases.configure(PurchasesConfiguration(apiKey));

  void setLogLevel(LogLevel level) => Purchases.setLogLevel(level);

  Future<Offerings> getOfferings() => Purchases.getOfferings();

  Future<CustomerInfo> getCustomerInfo() => Purchases.getCustomerInfo();

  Future<LogInResult> logIn(String appUserId) => Purchases.logIn(appUserId);

  Future<CustomerInfo> purchasePackage(Package package) =>
      Purchases.purchasePackage(package);

  Future<bool> get isAnonymous => Purchases.isAnonymous;

  Future<CustomerInfo> logOut() => Purchases.logOut();

  Future<CustomerInfo> restorePurchases() => Purchases.restorePurchases();
}
