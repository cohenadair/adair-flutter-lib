import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';

class AppCheckWrapper {
  static var _instance = AppCheckWrapper._();

  static AppCheckWrapper get get => _instance;

  @visibleForTesting
  static void set(AppCheckWrapper wrapper) => _instance = wrapper;

  @visibleForTesting
  static void reset() => _instance = AppCheckWrapper._();

  AppCheckWrapper._();

  Future<void> activate({
    AndroidAppCheckProvider providerAndroid =
        const AndroidPlayIntegrityProvider(),
    AppleAppCheckProvider providerApple =
        const AppleAppAttestWithDeviceCheckFallbackProvider(),
  }) => FirebaseAppCheck.instance.activate(
    providerAndroid: providerAndroid,
    providerApple: providerApple,
  );
}
