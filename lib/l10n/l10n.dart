import 'package:adair_flutter_lib/l10n/gen/adair_flutter_lib_localizations.dart';
import 'package:adair_flutter_lib/utils/root.dart';

class L10n {
  static final _instance = L10n._();

  static L10n get get => _instance;

  // Note that the testable methods, set and reset, have been intentionally
  // omitted; tests should always use the real instance of L10n (see the
  // Testable widget).

  L10n._();

  AdairFlutterLibLocalizations get lib =>
      AdairFlutterLibLocalizations.of(Root.get.buildContext);
}
