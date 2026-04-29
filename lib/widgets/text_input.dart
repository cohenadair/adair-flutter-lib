import 'package:adair_flutter_lib/l10n/l10n.dart';
import 'package:adair_flutter_lib/res/style.dart';
import 'package:adair_flutter_lib/utils/validator.dart';
import 'package:adair_flutter_lib/widgets/input_controller.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

class TextInput extends StatefulWidget {
  static const int _inputLimitDefault = 40;
  static const int _inputLimitName = _inputLimitDefault;
  static const int _inputLimitNumber = 10;
  static const int _inputLimitEmail = 64;

  final String? initialValue;
  final String? label;
  final String? suffixText;
  final String? hintText;
  final TextCapitalization capitalization;
  final TextInputAction? textInputAction;

  /// The controller for the [TextInput]. The [TextInput] will update the
  /// controller's [validate] property automatically.
  final TextInputController? controller;

  final bool isEnabled;
  final bool isAutofocused;
  final bool obscuresText;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;

  /// Invoked when the [TextInput] text changes, _after_ [Validator.run] is
  /// invoked. Implement this property to update the state of the parent
  /// widget.
  final ValueChanged<String>? onChanged;

  /// Invoked when the "return" button is pressed on the keyboard when this
  /// [TextInput] is in focus.
  final VoidCallback? onSubmitted;

  /// See [TextField.focusNode].
  final FocusNode? focusNode;

  const TextInput({
    this.initialValue,
    this.label,
    this.suffixText,
    this.hintText,
    this.capitalization = TextCapitalization.none,
    this.textInputAction,
    required this.controller,
    this.isEnabled = true,
    this.isAutofocused = false,
    this.focusNode,
    this.obscuresText = false,
    this.maxLength = _inputLimitDefault,
    this.maxLines,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
  });

  TextInput.name(
    BuildContext context, {
    String? label,
    String? initialValue,
    required TextInputController controller,
    bool isEnabled = true,
    bool isAutofocused = false,
    ValueChanged<String>? onChanged,
    TextInputAction? textInputAction,
  }) : this(
         initialValue: initialValue,
         label: isEmpty(label) ? L10n.get.lib.inputNameLabel : label,
         capitalization: TextCapitalization.words,
         controller: controller,
         maxLength: _inputLimitName,
         maxLines: 1,
         isEnabled: isEnabled,
         isAutofocused: isAutofocused,
         onChanged: onChanged,
         textInputAction: textInputAction,
       );

  TextInput.description(
    BuildContext context, {
    String? title,
    String? initialValue,
    String? hintText,
    required TextInputController controller,
    bool isEnabled = true,
    bool isAutofocused = false,
    ValueChanged<String>? onChanged,
  }) : this(
         initialValue: initialValue,
         label: title ?? L10n.get.lib.inputDescriptionLabel,
         capitalization: TextCapitalization.sentences,
         controller: controller,
         maxLength: null, // No limit.
         isEnabled: isEnabled,
         isAutofocused: isAutofocused,
         onChanged: onChanged,
         hintText: hintText,
       );

  TextInput.number(
    BuildContext context, {
    double? initialValue,
    String? label,
    String? suffixText,
    String? requiredText,
    String? hintText,
    required NumberInputController? controller,
    bool isEnabled = true,
    bool isAutofocused = false,
    bool required = false,
    bool signed = true,
    bool decimal = true,
    bool showMaxLength = true,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
  }) : this(
         initialValue: initialValue?.toString(),
         label: label,
         suffixText: suffixText,
         hintText: hintText,
         controller: controller,
         keyboardType: TextInputType.numberWithOptions(
           signed: signed,
           decimal: decimal,
         ),
         isEnabled: isEnabled,
         isAutofocused: isAutofocused,
         maxLength: showMaxLength ? _inputLimitNumber : null,
         maxLines: 1,
         textInputAction: textInputAction,
         onChanged: onChanged,
       );

  TextInput.email(
    BuildContext context, {
    String? initialValue,
    required EmailInputController controller,
    bool isEnabled = true,
    bool isAutofocused = false,
    bool hideMaxLength = false,
    ValueChanged<String>? onChanged,
    TextInputAction? textInputAction,
    VoidCallback? onSubmitted,
  }) : this(
         initialValue: initialValue,
         label: L10n.get.lib.inputEmailLabel,
         capitalization: TextCapitalization.none,
         controller: controller,
         maxLength: hideMaxLength ? null : _inputLimitEmail,
         maxLines: 1,
         isEnabled: isEnabled,
         isAutofocused: isAutofocused,
         onChanged: onChanged,
         textInputAction: textInputAction,
         onSubmitted: onSubmitted,
       );

  @override
  TextInputState createState() => TextInputState();
}

class TextInputState extends State<TextInput> {
  static const _maxErrorHintLines = 2;

  ValidationCallback? get _validationCallback =>
      widget.controller?.validator?.run(context, widget.controller!.value);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateError();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: TextFormField(
        initialValue: widget.initialValue,
        controller: widget.controller?.editingController,
        decoration: InputDecoration(
          labelText: widget.label,
          errorText: widget.controller?.error,
          errorMaxLines: _maxErrorHintLines,
          suffixText: widget.suffixText,
          suffixStyle: styleSecondary(context),
          hintText: widget.hintText,
          hintMaxLines: _maxErrorHintLines,
        ),
        style: widget.isEnabled ? null : styleDisabled(context),
        textCapitalization: widget.capitalization,
        textInputAction: widget.textInputAction,
        enabled: widget.isEnabled,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        onChanged: (value) {
          widget.onChanged?.call(value);
          setState(_updateError);
        },
        onFieldSubmitted: (_) => widget.onSubmitted?.call(),
        autofocus: widget.isAutofocused,
        obscureText: widget.obscuresText,
        focusNode: widget.focusNode,
      ),
    );
  }

  void _updateError() {
    widget.controller?.error = _validationCallback?.call(context);
  }
}
