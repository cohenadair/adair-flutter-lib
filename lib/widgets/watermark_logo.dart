import 'package:adair_flutter_lib/res/theme.dart';
import 'package:adair_flutter_lib/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../app_config.dart';
import '../res/dimen.dart';

class WatermarkLogo extends StatelessWidget {
  static const _size = 150.0;

  final IconData icon;
  final Color? color;
  final String? title;

  const WatermarkLogo({required this.icon, this.color, this.title});

  @override
  Widget build(BuildContext context) {
    Widget titleWidget = const SizedBox();
    if (isNotEmpty(title)) {
      titleWidget = Padding(
        padding: insetsTopDefault,
        child: TitleText.style1(
          title!,
          overflow: TextOverflow.visible,
          align: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        ClipOval(
          child: Container(
            padding: insetsXL,
            color: context.colorGreyAccentLight,
            child: Icon(
              icon,
              size: _size,
              color: color ?? AppConfig.get.colorAppTheme,
            ),
          ),
        ),
        titleWidget,
      ],
    );
  }
}
