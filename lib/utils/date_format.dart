import 'package:intl/intl.dart';

import '../l10n/l10n.dart';

extension DateFormats on DateFormat {
  static DateFormat localized(String format) =>
      DateFormat(format, L10n.get.lib.localeName);
}
