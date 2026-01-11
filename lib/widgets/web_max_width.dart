import "package:adair_flutter_lib/wrappers/io_wrapper.dart";
import "package:flutter/widgets.dart";

class WebMaxWidth extends StatelessWidget {
  static const _defaultMaxWidth = 500.0;

  final Widget child;
  final double maxWidth;

  const WebMaxWidth({required this.child, this.maxWidth = _defaultMaxWidth});

  @override
  Widget build(BuildContext context) {
    if (!IoWrapper.get.isWeb) {
      return child;
    }

    return Center(
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
