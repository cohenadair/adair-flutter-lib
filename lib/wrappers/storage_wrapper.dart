import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageWrapper {
  static var _instance = StorageWrapper._();

  static StorageWrapper get get => _instance;

  @visibleForTesting
  static void set(StorageWrapper wrapper) => _instance = wrapper;

  @visibleForTesting
  static void reset() => _instance = StorageWrapper._();

  StorageWrapper._();

  Future<void> putData(String path, Uint8List bytes) async =>
      FirebaseStorage.instance.ref(path).putData(bytes);

  Future<String> getDownloadURL(String path) =>
      FirebaseStorage.instance.ref(path).getDownloadURL();
}
