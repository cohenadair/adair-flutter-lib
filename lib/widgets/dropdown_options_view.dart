import 'package:flutter/material.dart';

import '../res/dimen.dart';

/// A styled dropdown panel for displaying a list of options, consistent with
/// M3 design. Handles the [Material] container, elevation, rounded corners,
/// and height constraint. Width is determined by the parent's constraints.
///
/// Used by [AutocompleteTextInput] (via its options view builder) and
/// [DropdownAnchor] (via its overlay).
class DropdownOptionsView extends StatelessWidget {
  static const elevation = 2.0;
  static const outerBorderRadius = 16.0;

  /// Border radius applied to individual items inside the panel so their
  /// ink ripples are clipped to a rounded shape.
  static const innerBorderRadius = 12.0;

  final List<Widget> children;

  const DropdownOptionsView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(outerBorderRadius)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

/// A single tappable item inside a [DropdownOptionsView].
///
/// Applies the standard outer/inner padding and rounded [InkWell] ripple used
/// by all dropdown items.
class DropdownOptionItem extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const DropdownOptionItem({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: insetsTiny,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          DropdownOptionsView.innerBorderRadius,
        ),
        child: Padding(
          padding: insetsHorizontalDefaultVerticalSmall,
          child: child,
        ),
      ),
    );
  }
}

/// Positions a [DropdownOptionsView] below a trigger widget using an overlay.
///
/// The dropdown is dismissed by tapping outside it. The trigger and the
/// dropdown panel share a [TapRegion] group so that tapping either one does
/// not count as an "outside" tap.
class DropdownAnchor extends StatefulWidget {
  /// Builds the trigger widget. Call [open] to toggle the dropdown.
  final Widget Function(BuildContext context, VoidCallback open) triggerBuilder;

  /// Builds the list of items shown inside the [DropdownOptionsView]. Call
  /// [close] from any item that should dismiss the dropdown (e.g. a
  /// destructive action or navigation).
  final List<Widget> Function(VoidCallback close) childrenBuilder;

  /// When true, the dropdown expands to the left, anchored to the bottom-right
  /// of the trigger. Defaults to false (expands to the right).
  final bool alignRight;

  const DropdownAnchor({
    super.key,
    required this.triggerBuilder,
    required this.childrenBuilder,
    this.alignRight = false,
  });

  @override
  State<DropdownAnchor> createState() => _DropdownAnchorState();
}

class _DropdownAnchorState extends State<DropdownAnchor> {
  final _controller = OverlayPortalController();
  final _triggerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      groupId: this,
      child: OverlayPortal(
        controller: _controller,
        overlayChildBuilder: _buildOverlay,
        child: Container(
          key: _triggerKey,
          child: widget.triggerBuilder(context, _controller.toggle),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final triggerBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (triggerBox == null) {
      return const SizedBox();
    }
    final triggerGlobal = triggerBox.localToGlobal(Offset.zero);
    final triggerSize = triggerBox.size;
    final dropdownTop = triggerGlobal.dy + triggerSize.height;

    final view = View.of(context);
    final screenSize = view.physicalSize / view.devicePixelRatio;
    final screenWidth = screenSize.width;
    final maxHeight = screenSize.height - dropdownTop;

    return Positioned(
      top: dropdownTop,
      right: widget.alignRight
          ? screenWidth - triggerGlobal.dx - triggerSize.width
          : null,
      left: widget.alignRight ? null : triggerGlobal.dx,
      child: TapRegion(
        groupId: this,
        onTapOutside: (_) => _controller.hide(),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: IntrinsicWidth(
            child: DropdownOptionsView(
              children: widget.childrenBuilder(_controller.hide),
            ),
          ),
        ),
      ),
    );
  }
}
