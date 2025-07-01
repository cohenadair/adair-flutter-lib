import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:adair_flutter_lib/utils/log.dart';
import 'package:flutter/foundation.dart';

import 'managers/properties_manager.dart';
import 'managers/subscription_manager.dart';

class AdairFlutterLib {
  static var _instance = AdairFlutterLib._();

  static AdairFlutterLib get get => _instance;

  @visibleForTesting
  static void set(AdairFlutterLib manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = AdairFlutterLib._();

  AdairFlutterLib._();

  final _log = const Log("AdairFlutterLib");

  Future<void> init() async {
    await TimeManager.get.init();
    await PropertiesManager.get.init();
    await SubscriptionManager.get.init();
    _log.d("Flutter lib initialized");
  }
}
