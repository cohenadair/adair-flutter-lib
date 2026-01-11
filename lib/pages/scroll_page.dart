import 'package:adair_flutter_lib/widgets/web_max_width.dart';
import 'package:flutter/material.dart';

import '../res/dimen.dart';

class ScrollPage extends StatelessWidget {
  final ScrollController? controller;
  final AppBar? appBar;
  final List<Widget> children;

  /// See [Scaffold.persistentFooterButtons].
  final List<Widget> footer;

  final EdgeInsets padding;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  /// See [Scaffold.extendBodyBehindAppBar].
  final bool extendBodyBehindAppBar;

  final bool enableHorizontalSafeArea;
  final bool centerContent;
  final bool restrictWebWidth;

  /// When non-null, material swipe-to-refresh feature is enabled. See
  /// [RefreshIndicator.onRefresh].
  final Future<void> Function()? onRefresh;

  /// Sets the [RefreshIndicator] key, which can be used to hide/show the
  /// refresh indicator programmatically. This field is ignored if [onRefresh]
  /// is null.
  final Key? refreshIndicatorKey;

  const ScrollPage({
    this.controller,
    this.appBar,
    this.children = const [],
    this.footer = const [],
    this.padding = insetsZero,
    this.spacing = 0.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.extendBodyBehindAppBar = true,
    this.enableHorizontalSafeArea = true,
    this.centerContent = false,
    this.restrictWebWidth = false,
    this.onRefresh,
    this.refreshIndicatorKey,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Scrollable area should take up entire screen/parent, or drag
    //  effect (when not scrollable) on Android should be disabled if content
    //  doesn't actually require scrolling.
    // TODO: When centerContent is true, the content needs to be centered
    //  within the scroll view, rather than the scroll view itself being
    //  centered within the parent (for the same reason as above). Should test
    //  what happens on a native Android app and mimic that behaviour.

    Widget scrollView = SingleChildScrollView(
      // Apply vertical padding inside the child Column so scrolling isn't
      // cut off.
      padding: padding.copyWith(top: 0, bottom: 0),
      // Ensures view is scrollable, even when items don't exceed screen size.
      // This only applies when a persistent footer isn't being used.
      physics: footer.isEmpty ? const AlwaysScrollableScrollPhysics() : null,
      // Ensures items are not cut off when over-scrolling on iOS. This only
      // applies when a persistent footer isn't being used.
      clipBehavior: footer.isEmpty ? Clip.none : Clip.hardEdge,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: controller,
      child: SafeArea(
        left: enableHorizontalSafeArea,
        right: enableHorizontalSafeArea,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          spacing: spacing,
          children: [
            Container(height: padding.top),
            ...children,
            Container(height: padding.bottom),
          ],
        ),
      ),
    );

    if (centerContent) {
      scrollView = Center(child: scrollView);
    }

    var child = scrollView;
    if (onRefresh != null) {
      child = RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: onRefresh!,
        child: scrollView,
      );
    }

    if (restrictWebWidth) {
      child = WebMaxWidth(child: child);
    }

    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      persistentFooterButtons: footer.isEmpty ? null : footer,
      body: child,
    );
  }
}
