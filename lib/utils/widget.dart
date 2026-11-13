import 'dart:async';

import 'package:material_ui/material_ui.dart';

typedef WidgetCallback = Widget Function(BuildContext);

extension GlobalKeys on GlobalKey {
  /// Returns the global [Rect] occupied by this key's current render
  /// object, or `null` if it hasn't been laid out yet.
  Rect? globalPosition() {
    final obj = currentContext?.findRenderObject();
    if (obj is RenderBox) {
      return obj.localToGlobal(Offset.zero) & obj.size;
    }
    return null;
  }
}

/// Checks [state.mounted] before invoking [use]. This should always be used in a
/// [StatefulWidget] after asynchronous work as been done to ensure the widget
/// still exists (i.e. is mounted).
@Deprecated("Don't use, can cause false sense of security")
FutureOr<void> safeUseContext(
  State state,
  FutureOr<void> Function() use,
) async {
  if (!state.mounted) {
    return Future.value();
  }
  await use();
}

/// A [MaterialApp.builder] that lets dependencies still built on
/// `package:flutter/material.dart` resolve the app's theme and Material
/// localizations. Remove once every dependency has migrated to
/// `package:material_ui`.
Widget materialUiCompatibilityBuilder(BuildContext context, Widget? child) {
  // Deprecated only because it's a temporary migration utility.
  // ignore: deprecated_member_use
  return MaterialUiCompatibilityBridge(child: child!);
}
