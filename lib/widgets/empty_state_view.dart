import 'package:adair_flutter_lib/res/dimen.dart';
import 'package:adair_flutter_lib/res/theme.dart';
import 'package:flutter/material.dart';

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String title;
  final String description;

  const EmptyStateView({
    required this.icon,
    required this.iconSize,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: insetsDefault,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: context.colorApp),
            SizedBox(height: paddingLarge),
            Text(title, style: context.styleTitleLargeBold),
            SizedBox(height: paddingLarge),
            Text(
              description,
              style: TextStyle(color: context.colorSecondaryText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
