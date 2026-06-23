import 'package:adair_flutter_lib/managers/subscription_manager.dart';
import 'package:adair_flutter_lib/utils/dialog.dart';
import 'package:adair_flutter_lib/widgets/padded_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

class ProCheckboxInput extends StatefulWidget {
  final String label;
  final String? description;
  final String? helpText;
  final bool value;
  final Widget? leading;
  final EdgeInsets? padding;
  final VoidCallback onProRequired;
  final void Function(bool) onSetValue;

  const ProCheckboxInput({
    required this.label,
    this.description,
    this.helpText,
    required this.value,
    this.leading,
    this.padding,
    required this.onProRequired,
    required this.onSetValue,
  });

  @override
  State<ProCheckboxInput> createState() => _ProCheckboxInputState();
}

class _ProCheckboxInputState extends State<ProCheckboxInput> {
  var _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.value;
  }

  @override
  void didUpdateWidget(ProCheckboxInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _isChecked = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxInput(
      label: widget.label,
      description: widget.description,
      helpText: widget.helpText,
      value: SubscriptionManager.get.isPro && _isChecked,
      leading: widget.leading,
      padding: widget.padding,
      onChanged: (checked) {
        if (SubscriptionManager.get.isPro && checked) {
          _setIsChecked(true);
        } else if (checked) {
          _setIsChecked(false);
          widget.onProRequired();
        } else {
          _setIsChecked(false);
        }
      },
    );
  }

  void _setIsChecked(bool isChecked) {
    setState(() {
      _isChecked = isChecked;
      widget.onSetValue(isChecked);
    });
  }
}

class CheckboxInput extends StatelessWidget {
  final String label;
  final String? description;
  final String? helpText;
  final bool value;
  final bool enabled;
  final Widget? leading;
  final EdgeInsets? padding;
  final void Function(bool)? onChanged;

  CheckboxInput({
    required this.label,
    this.description,
    this.helpText,
    this.value = false,
    this.enabled = true,
    this.leading,
    this.padding,
    this.onChanged,
  }) : assert(isNotEmpty(label));

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: padding,
      leading: leading,
      title: _buildTitle(context),
      subtitle: _buildSubtitle(context),
      trailing: PaddedCheckbox(
        isChecked: value,
        isEnabled: enabled,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final labelWidget = Text(
      label,
      style: enabled == false
          ? TextStyle(color: Theme.of(context).disabledColor)
          : null,
    );

    if (helpText == null) {
      return labelWidget;
    }

    return Row(
      children: [
        labelWidget,
        IconButton(
          icon: const Icon(Icons.help_outline),
          visualDensity: VisualDensity.compact,
          onPressed: () =>
              showOkDialog(context: context, description: Text(helpText!)),
        ),
      ],
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    if (isEmpty(description)) {
      return null;
    }

    return Text(
      description!,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
        color: enabled == false ? Theme.of(context).disabledColor : null,
      ),
      overflow: TextOverflow.visible,
    );
  }
}
