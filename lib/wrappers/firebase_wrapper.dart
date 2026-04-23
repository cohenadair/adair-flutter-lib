import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseWrapper {
  static var _instance = FirebaseWrapper._();

  static FirebaseWrapper get get => _instance;

  @visibleForTesting
  static void set(FirebaseWrapper wrapper) => _instance = wrapper;

  @visibleForTesting
  static void reset() => _instance = FirebaseWrapper._();

  FirebaseWrapper._();

  Future<void> initializeApp({FirebaseOptions? options}) =>
      Firebase.initializeApp(options: options);
}
