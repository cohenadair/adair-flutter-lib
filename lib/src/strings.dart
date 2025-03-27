import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../l10n/gen/adair_flutter_lib_localizations.dart';

/// A convenience wrapper to access the package's strings.
@internal
class Strings {
  static AdairFlutterLibLocalizations of(BuildContext context) {
    return Localizations.of<AdairFlutterLibLocalizations>(
      context,
      AdairFlutterLibLocalizations,
    )!;
  }
}
