import 'package:adair_flutter_lib/res/dimen.dart';
import 'package:adair_flutter_lib/res/theme.dart';
import 'package:adair_flutter_lib/widgets/enabled_opacity.dart';
import 'package:flutter/material.dart';

/// A [Checkbox] widget with optional padding. By default there is zero padding,
/// allowing the [PaddedCheckbox] to horizontally align perfectly with
/// surrounding UI elements (vs. including the padding of a built-in
/// [Checkbox]).
class PaddedCheckbox extends StatefulWidget {
  final bool isChecked;
  final bool isEnabled;
  final EdgeInsets padding;
  final void Function(bool)? onChanged;

  const PaddedCheckbox({
    this.isChecked = false,
    this.isEnabled = true,
    this.padding = insetsZero,
    this.onChanged,
  });

  @override
  PaddedCheckboxState createState() => PaddedCheckboxState();
}

class PaddedCheckboxState extends State<PaddedCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  void didUpdateWidget(PaddedCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_isChecked != widget.isChecked) {
      _isChecked = widget.isChecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return EnabledOpacity(
      isEnabled: widget.isEnabled,
      child: Padding(
        padding: widget.padding,
        child: SizedBox(
          width: checkboxSizeDefault,
          height: checkboxSizeDefault,
          child: Checkbox(
            activeColor: context.colorApp,
            value: _isChecked,
            onChanged: widget.isEnabled
                ? (_) => setState(() {
                    _isChecked = !_isChecked;
                    widget.onChanged?.call(_isChecked);
                  })
                : null,
          ),
        ),
      ),
    );
  }
}
