import "package:flutter/widgets.dart";

class RestrictedWidth extends StatelessWidget {
  static const _defaultMaxWidth = 500.0;

  final Widget child;
  final double maxWidth;

  const RestrictedWidth({
    required this.child,
    this.maxWidth = _defaultMaxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth < _defaultMaxWidth) {
          return child;
        }
        return Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        );
      },
    );
  }
}
