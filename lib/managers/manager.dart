abstract class Manager {
  Future<void> init();

  /// Called by `AuthManager.signOut` before the user is signed out, while
  /// they're still authenticated. Override to clean up per-user state,
  /// including writes that need the user's auth token. Does nothing by
  /// default.
  Future<void> onSignOut() async {}
}
