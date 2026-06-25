import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PathProviderWrapper {
  static var _instance = PathProviderWrapper._();

  static PathProviderWrapper get get => _instance;

  @visibleForTesting
  static void set(PathProviderWrapper wrapper) => _instance = wrapper;

  @visibleForTesting
  static void reset() => _instance = PathProviderWrapper._();

  PathProviderWrapper._();

  Future<String> get appDocumentsPath async =>
      (await getApplicationDocumentsDirectory()).path;

  Future<String> get temporaryPath async =>
      (await getTemporaryDirectory()).path;
}
