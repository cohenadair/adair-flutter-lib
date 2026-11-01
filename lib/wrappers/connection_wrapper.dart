import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionWrapper {
  static var _instance = ConnectionWrapper._();

  static ConnectionWrapper get get => _instance;

  @visibleForTesting
  static void set(ConnectionWrapper wrapper) => _instance = wrapper;

  @visibleForTesting
  static void reset() => _instance = ConnectionWrapper._();

  ConnectionWrapper._();

  /// Checks [uris], if non-null, in place of the package's default hosts. Any
  /// HTTP response from them counts as access, since a server root often
  /// responds with an error status (e.g. 404).
  Future<bool> hasInternetAccess({List<Uri>? uris}) {
    if (uris == null) {
      return InternetConnection().hasInternetAccess;
    }

    return InternetConnection.createInstance(
      useDefaultOptions: false,
      customCheckOptions: uris
          .map(
            (uri) =>
                InternetCheckOption(uri: uri, responseStatusFn: (_) => true),
          )
          .toList(),
    ).hasInternetAccess;
  }
}
