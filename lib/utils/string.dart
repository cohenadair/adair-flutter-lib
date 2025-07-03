import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

// TODO: Remove. Use L10n instead.
typedef StringCallback = String Function(BuildContext);

int Function(String, String) get ignoreCaseAlphabeticalComparator =>
    (lhs, rhs) => compareIgnoreCase(lhs, rhs);

/// Supported formats:
///   - %s
/// For each argument, toString() is called to replace %s.
@Deprecated("Strings should be correctly internationalized")
String format(String s, List<dynamic> args) {
  int index = 0;
  return s.replaceAllMapped(RegExp(r'%s'), (Match match) {
    return args[index++].toString();
  });
}

/// A trimmed, case-insensitive string comparison.
bool equalsTrimmedIgnoreCase(String s1, String s2) {
  return s1.trim().toLowerCase() == s2.trim().toLowerCase();
}

bool containsTrimmedLowerCase(String fullString, String filter) =>
    fullString.toLowerCase().trim().contains(filter.toLowerCase().trim());

String formatList(List<String> items) {
  return items.where(isNotEmpty).join(", ");
}

bool parseBoolFromInt(String str) {
  var intBool = int.tryParse(str);
  if (intBool == null) {
    return false;
  } else {
    return intBool == 1 ? true : false;
  }
}

String newLineOrEmpty(String input) => input.isEmpty ? "" : "\n";
