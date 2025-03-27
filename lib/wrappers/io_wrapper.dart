import 'dart:io';

import 'package:flutter/material.dart';

class IoWrapper {
  static var _instance = IoWrapper._();

  static IoWrapper get get => _instance;

  @visibleForTesting
  static void set(IoWrapper manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = IoWrapper._();

  IoWrapper._();

  Future<List<InternetAddress>> lookup(String host) async {
    try {
      return await InternetAddress.lookup(host);
    } catch (_) {
      return Future.value([]);
    }
  }

  bool get isAndroid => Platform.isAndroid;

  bool get isIOS => Platform.isIOS;
}
