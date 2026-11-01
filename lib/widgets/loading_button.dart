import 'package:flutter/material.dart';

import 'loading.dart';

/// An [ElevatedButton] that, while [isLoading], is disabled and shows a
/// loading indicator in place of its text. The text's space is always
/// reserved, so the button doesn't change size.
class LoadingButton extends StatelessWidget {
  static const _loadingSize = 16.0;

  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const LoadingButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [_buildText(), _buildLoading()],
      ),
    );
  }

  Widget _buildText() {
    return Visibility(
      visible: !isLoading,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Text(text),
    );
  }

  Widget _buildLoading() {
    return Loading.minimized(isShowing: isLoading, size: _loadingSize);
  }
}
