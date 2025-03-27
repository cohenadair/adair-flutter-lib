import 'package:adair_flutter_lib/app_config.dart';
import 'package:flutter/material.dart';

class AppColorIcon extends StatelessWidget {
  final IconData data;

  const AppColorIcon(this.data);

  @override
  Widget build(BuildContext context) {
    return Icon(data, color: AppConfig.get.colorAppTheme);
  }
}
