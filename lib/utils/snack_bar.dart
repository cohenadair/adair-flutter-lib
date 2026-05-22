import 'package:flutter/material.dart';

const int snackBarDurationDefault = 5;

SnackBar errorSnackBar(String message, ThemeData themeData) {
  return SnackBar(
    content: Text(message),
    duration: const Duration(seconds: snackBarDurationDefault),
    backgroundColor: themeData.colorScheme.error,
  );
}

void showErrorSnackBar(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(errorSnackBar(errorMessage, Theme.of(context)));
}

void showNoticeSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: snackBarDurationDefault),
    ),
  );
}

void showPermanentSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(days: 365)),
  );
}
