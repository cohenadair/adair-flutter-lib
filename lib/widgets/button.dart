import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;

  /// Set to `null` to disable the button.
  final VoidCallback? onPressed;
  final Icon? icon;
  final Color? color;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return icon == null
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(backgroundColor: color),
            child: _textWidget,
          )
        : ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon!,
            label: _textWidget,
            style: ElevatedButton.styleFrom(backgroundColor: color),
          );
  }

  Widget get _textWidget => Text(text.toUpperCase());
}
