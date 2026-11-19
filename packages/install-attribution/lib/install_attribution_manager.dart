import 'dart:async';

import 'package:adair_flutter_lib/managers/manager.dart';
import 'package:adair_flutter_lib/utils/log.dart';
import 'package:adair_flutter_lib/wrappers/method_channel_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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

  // Keys of the native error details, and the SKAdNetwork values to match.
  static const _detailsDomain = "domain";
  static const _detailsCode = "code";
  static const _skanErrorDomain = "SKANErrorDomain";
  static const _skanErrorUnknown = 10;

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
      if (_isSkanUnknownError(e)) {
        // Only seen on iOS 15-17, where it repeats on every launch for the
        // same device. Nothing in the app can fix it, so don't report it.
        _log.w("Registering install attribution: $e");
      } else {
        _log.e(e, reason: "Registering install attribution");
      }
    }
  }

  /// True if [e] is SKAdNetwork's catch-all `SKANErrorUnknown` (code 10).
  bool _isSkanUnknownError(Object e) {
    if (e is! PlatformException) {
      return false;
    }
    final details = e.details;
    return details is Map &&
        details[_detailsDomain] == _skanErrorDomain &&
        details[_detailsCode] == _skanErrorUnknown;
  }
}
