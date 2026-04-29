import 'package:adair_flutter_lib/utils/number.dart';
import 'package:adair_flutter_lib/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

/// A class for storing a value of an input widget, such as a text field or
/// check box.
class InputController<T> extends ValueNotifier<T?> {
  /// The current error message for the [InputController], if there is one.
  String? error;

  InputController({T? value}) : super(value);

  bool get hasValue => value != null;

  void clear() {
    value = null;
  }
}

class TextInputController extends InputController<String> {
  final TextEditingController editingController;
  Validator? validator;

  TextInputController({
    TextEditingController? editingController,
    this.validator,
  }) : editingController = editingController ?? TextEditingController(),
       super();

  TextInputController.name() : this(validator: NameValidator());

  @override
  String? get value {
    var text = editingController.text.trim();
    if (isEmpty(text)) {
      return null;
    }
    return text;
  }

  @override
  set value(String? value) =>
      editingController.text = isEmpty(value) ? "" : value!.trim();

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  void clear() {
    editingController.clear();
  }

  void clearText() {
    editingController.value = const TextEditingValue(text: "");
  }

  bool isValid(BuildContext context) =>
      isEmpty(validator?.run(context, value)?.call(context));

  /// Validates the controller's input immediately. This should only be called
  /// in special cases where an input field's validity depends on another input
  /// field's value.
  ///
  /// In most cases, input fields are automatically validated when input
  /// changes.
  ///
  /// This method should be called within a [setState] call.
  void validate(BuildContext context) {
    error = validator?.run(context, value)?.call(context);
  }
}

class NumberInputController extends TextInputController {
  NumberInputController({
    TextEditingController? editingController,
    Validator? validator,
  }) : super(
         editingController: editingController ?? TextEditingController(),
         validator: validator ?? DoubleValidator(),
       );

  bool get hasDoubleValue => doubleValue != null;

  double? get doubleValue => value == null ? null : tryParseDouble(value!);

  set doubleValue(double? value) => super.value = value?.toString();

  bool get hasIntValue => intValue != null;

  int? get intValue => value == null ? null : int.tryParse(value!);

  set intValue(int? value) => super.value = value?.toString();
}

class EmailInputController extends TextInputController {
  EmailInputController({
    TextEditingController? editingController,
    bool required = false,
  }) : super(
         editingController: editingController ?? TextEditingController(),
         validator: EmailValidator(isRequired: required),
       );
}
