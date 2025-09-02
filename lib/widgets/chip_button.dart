import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../app_config.dart';
import '../res/style.dart';

/// An [ActionChip] wrapper.
class ChipButton extends StatelessWidget {
  final double _iconSize = 20.0;
  final double _fontSize = 13.0;

  final String label;
  final IconData? icon;
  final Color? textColor;
  final VoidCallback? onPressed;

  ChipButton({required this.label, this.icon, this.textColor, this.onPressed})
    : assert(isNotEmpty(label));

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: icon == null
          ? null
          : Icon(icon, size: _iconSize, color: textColor ?? Colors.black),
      label: Text(
        label,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontSize: _fontSize,
          fontWeight: fontWeightBold,
        ),
      ),
      backgroundColor: AppConfig.get.colorAppTheme,
      disabledColor: AppConfig.get.colorAppTheme,
      pressElevation: 1,
      onPressed: onPressed,
    );
  }
}
