import 'package:adair_flutter_lib/res/theme.dart';
import 'package:flutter/material.dart';

import '../app_config.dart';

class TransparentAppBar extends AppBar {
  TransparentAppBar(
    BuildContext context, {
    Widget? leading,
    VoidCallback? onCloseOverride,
  }) : super(
         backgroundColor: Colors.transparent,
         elevation: 0.0,
         leading:
             leading ??
             CloseButton(
               color: AppConfig.get.colorAppTheme,
               onPressed: onCloseOverride,
             ),
         systemOverlayStyle: context.appBarSystemStyle,
       );
}
