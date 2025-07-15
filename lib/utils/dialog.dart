import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

void showDeleteDialog({
  required BuildContext context,
  String? title,
  String? description,
  required VoidCallback onDelete,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title == null ? null : Text(title),
        content: description == null ? null : Text(description),
        actions: <Widget>[
          DialogButton(label: L10n.get.lib.cancel),
          DialogButton(
            label: L10n.get.lib.delete,
            textColor: Colors.red,
            onTap: onDelete,
          ),
        ],
      );
    },
  );
}

void showWarningDialog({
  required BuildContext context,
  required VoidCallback onContinue,
  String? description,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(L10n.get.lib.warning),
        content: description == null ? null : Text(description),
        actions: <Widget>[
          DialogButton(label: L10n.get.lib.cancel),
          DialogButton(
            label: L10n.get.lib.continueString,
            textColor: Colors.red,
            onTap: onContinue,
          ),
        ],
      );
    },
  );
}

void showErrorDialog({
  required BuildContext context,
  required String description,
}) {
  showOkDialog(
    context: context,
    title: L10n.get.lib.error,
    description: description,
  );
}

void showOkDialog({
  required BuildContext context,
  String? title,
  String? description,
  VoidCallback? onTapOk,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title == null ? null : Text(title),
        content: description == null ? null : Text(description),
        actions: <Widget>[DialogButton(label: L10n.get.lib.ok, onTap: onTapOk)],
      );
    },
  );
}

void showErrorSnackBar(
  BuildContext context,
  String errorMessage, [
  Duration? duration,
]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessage, style: const TextStyle(color: Colors.white)),
      duration: duration ?? const Duration(seconds: 5),
      backgroundColor: Colors.red,
    ),
  );
}

class DialogButton extends StatelessWidget {
  final String label;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool popOnTap;
  final bool isEnabled;

  const DialogButton({
    required this.label,
    this.textColor,
    this.onTap,
    this.popOnTap = true,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    VoidCallback? onPressed;
    if (isEnabled) {
      onPressed = () {
        onTap?.call();
        if (popOnTap) {
          Navigator.pop(context);
        }
      };
    }

    return TextButton(
      style: TextButton.styleFrom(foregroundColor: textColor),
      onPressed: onPressed,
      child: Text(label.toUpperCase()),
    );
  }
}
