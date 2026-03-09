import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreWrapper {
  static var _instance = FirestoreWrapper._();

  static FirestoreWrapper get get => _instance;

  @visibleForTesting
  static void set(FirestoreWrapper wrapper) => _instance = wrapper;

  @visibleForTesting
  static void reset() => _instance = FirestoreWrapper._();

  FirestoreWrapper._();

  DocumentReference<Map<String, dynamic>> doc(String path) =>
      FirebaseFirestore.instance.doc(path);
}
