import 'package:flutter/material.dart';

/// A test widget that allows testing of [child.dispose] by invoking
/// [DisposableTesterState.removeChild].
class DisposableTester extends StatefulWidget {
  final Widget child;

  const DisposableTester({required this.child});

  @override
  DisposableTesterState createState() => DisposableTesterState();
}

class DisposableTesterState extends State<DisposableTester> {
  bool _showChild = true;

  void removeChild() => setState(() => _showChild = false);

  @override
  Widget build(BuildContext context) =>
      _showChild ? widget.child : const SizedBox();
}
