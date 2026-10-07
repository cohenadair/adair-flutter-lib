import 'dart:async';

import 'package:adair_flutter_lib/managers/manager.dart';
import 'package:adair_flutter_lib/utils/log.dart';
import 'package:adair_flutter_lib/wrappers/method_channel_wrapper.dart';
import 'package:flutter/foundation.dart';

final _log = const Log("InstallAttributionManager");

/// Reports app installs to Meta so app-install ad campaigns can attribute
/// them. On iOS, this registers with SKAdNetwork (no Meta SDK, no ATT
/// prompt). On Android, this enables the Meta SDK and logs the activate-app
/// event; the app ID and client token are read from the app's manifest.
///
/// Opt-in: an app must call [init] itself. Nothing Meta-related runs
/// otherwise.
class InstallAttributionManager extends Manager {
  static var _instance = InstallAttributionManager._();

  static InstallAttributionManager get get => _instance;

  @visibleForTesting
  static void set(InstallAttributionManager manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = InstallAttributionManager._();

  InstallAttributionManager._();

  static const _channelName = "adair_install_attribution";
  static const _methodRegister = "register";

  /// Returns immediately; registration runs in the background so it never
  /// delays app startup. Never throws; failures are only logged.
  @override
  Future<void> init() async {
    unawaited(_register());
  }

  Future<void> _register() async {
    try {
      // The native side returns a description of the API it called, so the
      // code path taken can be verified from the debug console.
      _log.d(
        "Registered install attribution via "
        "${await MethodChannelWrapper.get.channel(_channelName).invokeMethod<String>(_methodRegister)}",
      );
    } catch (e) {
      _log.e(e, reason: "Registering install attribution");
    }
  }
}
