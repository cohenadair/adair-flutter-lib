import 'package:adair_flutter_lib/res/dimen.dart';
import 'package:adair_flutter_lib/res/theme.dart';
import 'package:flutter/material.dart';

class AppBarDropdown extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final MainAxisAlignment textAlignment;

  const AppBarDropdown({
    required this.title,
    this.onTap,
    this.padding = insetsZero,
    this.textAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: textAlignment,
          children: [
            Text(title, style: context.styleAppBarTitle),
            Icon(Icons.arrow_drop_down, color: context.colorOnAppBar),
          ],
        ),
      ),
    );
  }
}
