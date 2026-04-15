import 'package:flutter/material.dart';

// TODO: This widget is probably no longer needed, since with M3 we'll no longer
//  be using uppercase text buttons. This should be removed and replaced with
//  direct uses of the Flutter button widgets.
@Deprecated(
  "Use Flutter's built-in button widgets (ElevatedButton, TextButton, etc.) directly.",
)
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
