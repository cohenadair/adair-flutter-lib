import 'package:adair_flutter_lib/res/theme.dart';
import 'package:flutter/material.dart';

import 'empty_or.dart';

class ErrorText extends StatelessWidget {
  final String error;

  const ErrorText({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return EmptyOr(
      isShowing: error.isNotEmpty,
      builder: (context) => Text(error, style: context.styleError),
    );
  }
}
