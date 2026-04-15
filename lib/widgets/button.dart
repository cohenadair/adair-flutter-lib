import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;

  /// Set to `null` to disable the button.
  final VoidCallback? onPressed;
  final Icon? icon;
  final Color? color;
  final bool _isSecondary;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
  }) : _isSecondary = false;

  /// A secondary (text-style) button. Use for cancel or low-emphasis actions.
  /// Set [onPressed] to `null` to disable.
  const Button.secondary({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  }) : _isSecondary = true,
       color = null;

  @override
  Widget build(BuildContext context) {
    if (_isSecondary) {
      return icon == null
          ? TextButton(onPressed: onPressed, child: _buildTextWidget(context))
          : TextButton.icon(
              onPressed: onPressed,
              icon: icon!,
              label: _buildTextWidget(context),
            );
    }

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
