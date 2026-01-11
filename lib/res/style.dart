import 'package:adair_flutter_lib/res/theme.dart';
import 'package:flutter/material.dart';

// TODO: Stop using these and instead use theme + extension, which easily allows
//  for different themes:
//  https://chatgpt.com/share/695cfc4e-8aa8-800b-bc79-24ace9931387.

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

@Deprecated(
  "Use BuildContext.styleError and set primary font sizes in the app's "
  "ThemeData instead.",
)
TextStyle styleError(BuildContext context) =>
    stylePrimary(context).copyWith(color: Colors.red);

TextStyle styleSuccess(BuildContext context) =>
    stylePrimary(context).copyWith(color: Colors.green);

const TextStyle styleSubtext = TextStyle(fontSize: 13.0);

TextStyle styleSecondarySubtext(BuildContext context) =>
    TextStyle(fontSize: 11.0, color: styleSecondary(context).color);

TextStyle stylePrimary(BuildContext context, {bool enabled = true}) {
  return TextStyle(
    fontSize: 16.0,
    color: enabled ? null : Theme.of(context).disabledColor,
  );
}

TextStyle styleSecondary(BuildContext context) =>
    stylePrimary(context).copyWith(color: Colors.grey);
