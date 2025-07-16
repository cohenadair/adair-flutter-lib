import 'package:adair_flutter_lib/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../res/style.dart';

void showDeleteDialog({
  required BuildContext context,
  String? title,
  Widget? description,
  VoidCallback? onDelete,
}) {
  showDestructiveDialog(
    context: context,
    title: title ?? L10n.get.lib.delete,
    description: description,
    destroyText: L10n.get.lib.delete,
    onTapDestroy: onDelete,
  );
}

void showConfirmYesDialog({
  required BuildContext context,
  Widget? description,
  VoidCallback? onConfirm,
}) {
  showDestructiveDialog(
    context: context,
    description: description,
    cancelText: L10n.get.lib.no,
    destroyText: L10n.get.lib.yes,
    onTapDestroy: onConfirm,
  );
}

void showWarningDialog({
  required BuildContext context,
  String? title,
  Widget? description,
  VoidCallback? onContinue,
}) {
  showDestructiveDialog(
    context: context,
    title: title,
    description: description,
    destroyText: L10n.get.lib.continueString,
    onTapDestroy: onContinue,
    warning: true,
  );
}

void showErrorDialog({required BuildContext context, Widget? description}) {
  showOkDialog(
    context: context,
    title: L10n.get.lib.error,
    description: description,
  );
}

void showOkDialog({
  required BuildContext context,
  String? title,
  Widget? description,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: isEmpty(title) ? null : Text(title!),
      titleTextStyle: styleTitleAlert(context),
      content: description,
      actions: <Widget>[DialogButton(label: L10n.get.lib.ok)],
    ),
  );
}

Future<void> showCancelDialog(
  BuildContext context, {
  String? title,
  String? description,
  required String actionText,
  VoidCallback? onTapAction,
}) {
  assert(isNotEmpty(actionText));

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: isEmpty(title) ? null : Text(title!),
      titleTextStyle: styleTitleAlert(context),
      content: isEmpty(description) ? null : Text(description!),
      actions: <Widget>[
        DialogButton(label: L10n.get.lib.cancel),
        DialogButton(label: actionText, onTap: onTapAction),
      ],
    ),
  );
}

void showDestructiveDialog({
  required BuildContext context,
  String? title,
  Widget? description,
  String? cancelText,
  required String destroyText,
  VoidCallback? onTapDestroy,
  bool warning = false,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: title == null ? null : Text(title),
      titleTextStyle: styleTitleAlert(context),
      content: description,
      actions: <Widget>[
        DialogButton(label: cancelText ?? L10n.get.lib.cancel),
        DialogButton(
          label: destroyText,
          textColor: warning ? null : Colors.red,
          onTap: onTapDestroy,
        ),
      ],
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
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: textColor),
      onPressed: isEnabled
          ? () {
              onTap?.call();
              if (popOnTap) {
                Navigator.pop(context);
              }
            }
          : null,
      child: Text(label.toUpperCase()),
    );
  }
}
