import 'package:adair_flutter_lib/managers/manager.dart';
import 'package:flutter/foundation.dart';

import '../utils/log.dart';
import '../wrappers/firebase_auth_wrapper.dart';

final _log = Log("AuthManager");

/// Coordinates auth flows that involve more than one call, such as signing
/// out after every [Manager] has cleaned up its per-user state.
///
/// Other auth functions (the current user, auth state changes, signing in,
/// password reset emails) are in [FirebaseAuthWrapper]. Anything that is a
/// true single call to Firebase Auth belongs there, not here; only add
/// methods to this class when they coordinate multiple steps.
class AuthManager {
  /// How long a single [Manager.onSignOut] can take before sign-out moves
  /// on, so an offline write can't block sign-out indefinitely.
  static const _onSignOutTimeout = Duration(seconds: 5);

  static var _instance = AuthManager._();

  static AuthManager get get => _instance;

  @visibleForTesting
  static void set(AuthManager manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = AuthManager._();

  AuthManager._();

  var _managers = <Manager>[];

  /// Sets the managers whose [Manager.onSignOut] is called by [signOut].
  /// Called by `AdairFlutterLibApp` with its managers.
  set managers(List<Manager> managers) => _managers = managers;

  /// Calls [Manager.onSignOut] on every manager, in order, then signs the
  /// user out. A manager that fails, or takes longer than
  /// [_onSignOutTimeout], to clean up doesn't prevent sign-out.
  Future<void> signOut() async {
    for (final manager in _managers) {
      try {
        await manager.onSignOut().timeout(_onSignOutTimeout);
      } catch (e) {
        _log.e(e, reason: "Cleaning up ${manager.runtimeType} on sign-out");
      }
    }
    await FirebaseAuthWrapper.get.signOut();
  }
}
