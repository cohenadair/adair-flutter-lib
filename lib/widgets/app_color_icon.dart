import 'package:adair_flutter_lib/app_config.dart';
import 'package:material_ui/material_ui.dart';

class AppColorIcon extends StatelessWidget {
  final IconData data;

  const AppColorIcon(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(data, color: AppConfig.get.colorAppTheme);
  }
}
