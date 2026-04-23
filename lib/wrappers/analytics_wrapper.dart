import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AnalyticsWrapper {
  static var _instance = AnalyticsWrapper._();

  static AnalyticsWrapper get get => _instance;

  @visibleForTesting
  static void set(AnalyticsWrapper wrapper) => _instance = wrapper;

  @visibleForTesting
  static void reset() => _instance = AnalyticsWrapper._();

  AnalyticsWrapper._();

  Future<void> setAnalyticsCollectionEnabled(bool enabled) =>
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enabled);
}
