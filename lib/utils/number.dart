import 'package:adair_flutter_lib/utils/log.dart';

const _log = Log("NumberUtils");

/// Returns a parsed [double], taking commas as decimal delimiters into
/// account. If the input is empty or cannot be parsed, null is returned.
///
/// This function handles locale-aware parsing by cleaning the input before
/// calling [double.tryParse]. See [_cleanForParsing] for details.
double? tryParseDouble(String? input) {
  if (input == null || input.isEmpty) {
    return null;
  }

  var result = double.tryParse(_cleanForParsing(input));
  if (result == null) {
    _log.w("Failed to parse double: $input");
  }
  return result;
}

/// Removes all non-digit characters from input, and ensures the decimal
/// delimiter is a period. This is necessary because on iOS a person's number
/// format preference can be independent of their locale, so the intl
/// package's [NumberFormat] parsing doesn't work. For more details, see
/// https://github.com/dart-lang/i18n/issues/399.
String _cleanForParsing(String input) {
  if (input.isEmpty) {
    return input;
  }

  final lastComma = input.lastIndexOf(",");
  final lastPeriod = input.lastIndexOf(".");
  final lastSeparatorIndex = lastComma > lastPeriod ? lastComma : lastPeriod;

  final buffer = StringBuffer();

  for (int i = 0; i < input.length; i++) {
    final char = input[i];
    if (i == lastSeparatorIndex && (char == "," || char == ".")) {
      buffer.write(".");
    } else if (RegExp(r"\d").hasMatch(char)) {
      buffer.write(char);
    }
  }

  return buffer.toString();
}
