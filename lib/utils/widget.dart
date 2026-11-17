import 'dart:async';

// Used to pass useMaterial3 through to legacy Material dependencies.
// ignore: deprecated_member_use
import 'package:flutter/material.dart' as legacy show Theme, ThemeData;
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
  return MaterialUiCompatibilityBridge(
    // The bridge only maps colors, text, platform, and density, so legacy
    // ThemeData falls back to Material 3. Carry over the app's actual
    // useMaterial3 so legacy widgets (e.g. SfCalendar) keep their styling.
    //
    // The legacy Theme also inserts an IconTheme above the whole app, so
    // carry over the app's iconTheme too, or every icon and IconButton
    // outside a themed widget (e.g. ListTile) loses the app's icon color.
    child: Builder(
      builder: (context) {
        final bridged = legacy.Theme.of(context);
        return legacy.Theme(
          data: legacy.ThemeData(
            useMaterial3: Theme.of(context).useMaterial3,
            iconTheme: Theme.of(context).iconTheme,
            platform: bridged.platform,
            visualDensity: bridged.visualDensity,
            colorScheme: bridged.colorScheme,
            textTheme: bridged.textTheme,
          ),
          child: child!,
        );
      },
    ),
  );
}
