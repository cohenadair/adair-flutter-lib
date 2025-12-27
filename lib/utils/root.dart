import 'package:flutter/material.dart';

/// A convenience class for accessing the app's root object instances, such as
/// a [BuildContext]. These should be used sparingly and carefully, as it is
/// generally considered best practice to access the current tree's shallowest
/// object instance.
class Root {
  static final _instance = Root._();

  static Root get get => _instance;

  // Note that the testable methods, set and reset, have been intentionally
  // omitted; tests should always use the real instance of Root (see the
  // Testable widget).

  Root._();

  BuildContext? _buildContext;

  BuildContext get buildContext {
    assert(_buildContext != null, "Must set Root.get.buildContext");
    return _buildContext!;
  }

  set buildContext(BuildContext context) => _buildContext = context;
}
