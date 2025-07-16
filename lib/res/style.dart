import 'package:adair_flutter_lib/res/theme.dart';
import 'package:flutter/material.dart';

const FontWeight fontWeightBold = FontWeight.w500;

const TextStyle styleTitle1 = TextStyle(
  fontSize: 36,
  fontWeight: fontWeightBold,
);

TextStyle styleTitle2(BuildContext context) =>
    TextStyle(fontSize: 24, color: context.colorText);

TextStyle styleTitleAlert(BuildContext context) =>
    TextStyle(fontSize: 24, color: context.colorText);

TextStyle styleHyperlink(BuildContext context) => stylePrimary(
  context,
).copyWith(color: Colors.blue, decoration: TextDecoration.underline);

TextStyle styleError(BuildContext context) =>
    stylePrimary(context).copyWith(color: Colors.red);

TextStyle styleSuccess(BuildContext context) =>
    stylePrimary(context).copyWith(color: Colors.green);

const TextStyle styleSubtext = TextStyle(fontSize: 13.0);

TextStyle styleSecondarySubtext(BuildContext context) =>
    TextStyle(fontSize: 11.0, color: styleSecondary(context).color);

TextStyle stylePrimary(BuildContext context, {bool enabled = true}) {
  return Theme.of(context).textTheme.titleMedium!.copyWith(
    color: enabled
        ? Theme.of(context).textTheme.titleMedium!.color
        : Theme.of(context).disabledColor,
  );
}

TextStyle styleSecondary(BuildContext context) =>
    stylePrimary(context).copyWith(color: Colors.grey);
