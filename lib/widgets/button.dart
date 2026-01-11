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
            child: _buildTextWidget(context),
          )
        : ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon!,
            label: _buildTextWidget(context),
            style: ElevatedButton.styleFrom(backgroundColor: color),
          );
  }

  Widget _buildTextWidget(BuildContext context) =>
      Text(Theme.of(context).useMaterial3 ? text : text.toUpperCase());
}
