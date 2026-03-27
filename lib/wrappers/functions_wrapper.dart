import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class FunctionsWrapper {
  static var _instance = FunctionsWrapper._();

  static FunctionsWrapper get get => _instance;

  @visibleForTesting
  static void set(FunctionsWrapper wrapper) => _instance = wrapper;

  @visibleForTesting
  static void reset() => _instance = FunctionsWrapper._();

  FunctionsWrapper._();

  HttpsCallable httpCallable(String name, {HttpsCallableOptions? options}) =>
      FirebaseFunctions.instance.httpsCallable(name, options: options);
}
