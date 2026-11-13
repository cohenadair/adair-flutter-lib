import 'package:adair_flutter_lib/res/theme.dart';
import 'package:material_ui/material_ui.dart';

import 'empty_or.dart';

class ErrorText extends StatelessWidget {
  final String error;
  final TextAlign? textAlign;

  const ErrorText({super.key, required this.error, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return EmptyOr(
      isShowing: error.isNotEmpty,
      builder: (context) =>
          Text(error, style: context.styleError, textAlign: textAlign),
    );
  }
}
