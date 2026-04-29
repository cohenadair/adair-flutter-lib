import 'package:adair_flutter_lib/l10n/l10n.dart';
import 'package:adair_flutter_lib/utils/number.dart';
import 'package:adair_flutter_lib/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

/// A function called to validate input. A function is used to pass a
/// [BuildContext] instance for using localized strings.
typedef ValidationCallback = String? Function(BuildContext context);

// ignore: one_member_abstracts
abstract class Validator {
  ValidationCallback? run(BuildContext context, String? newValue);
}

/// A generic validator used for inline validator creation.
class GenericValidator implements Validator {
  final ValidationCallback Function(BuildContext, String?) runner;

  GenericValidator(this.runner);

  @override
  ValidationCallback run(BuildContext context, String? newValue) {
    return runner(context, newValue);
  }
}

/// A [Validator] for validating name inputs. This validator checks:
///   - Whether the new name equals the old name
///   - Whether the name is empty
///   - Whether the name exists via [nameExists].
class NameValidator implements Validator {
  /// If non-null, input equal to [oldName] is considered valid.
  final String? oldName;

  final StringCallback? nameExistsMessage;
  final bool Function(String)? nameExists;

  NameValidator({this.nameExistsMessage, this.nameExists, this.oldName})
    : assert(
        (nameExists != null && nameExistsMessage != null) ||
            (nameExists == null && nameExistsMessage == null),
      );

  @override
  ValidationCallback? run(BuildContext context, String? newName) {
    if (!isEmpty(oldName) &&
        !isEmpty(newName) &&
        equalsTrimmedIgnoreCase(oldName!, newName!)) {
      return null;
    } else if (isEmpty(newName)) {
      return (_) => L10n.get.lib.inputGenericRequired;
    } else if (nameExists != null && nameExists!(newName!)) {
      return nameExistsMessage;
    } else {
      return null;
    }
  }
}

class DoubleValidator implements Validator {
  @override
  ValidationCallback? run(BuildContext context, String? newValue) {
    if (isNotEmpty(newValue) && tryParseDouble(newValue!) == null) {
      return (_) => L10n.get.lib.inputInvalidNumber;
    }
    return null;
  }
}

/// A [DoubleValidator] that also checks for non-empty input and supports an
/// optional custom validation callback for additional constraints.
class CustomDoubleValidator extends DoubleValidator {
  final ValidationCallback? Function(BuildContext, String)? runner;

  CustomDoubleValidator({this.runner});

  @override
  ValidationCallback? run(BuildContext context, String? newValue) {
    var error = EmptyValidator().run(context, newValue);
    if (error != null) {
      return error;
    }

    error = super.run(context, newValue);
    if (error != null) {
      return error;
    } else {
      return runner?.call(context, newValue!);
    }
  }
}

class EmailValidator implements Validator {
  final bool isRequired;

  EmailValidator({this.isRequired = false});

  @override
  ValidationCallback? run(BuildContext context, String? newValue) {
    if (!isRequired && isEmpty(newValue)) {
      return null;
    }

    if (isRequired && isEmpty(newValue)) {
      return (_) => L10n.get.lib.inputGenericRequired;
    }

    if (newValue == null ||
        !RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
        ).hasMatch(newValue)) {
      return (_) => L10n.get.lib.inputInvalidEmail;
    }

    return null;
  }
}

/// A validator that ensures input is not empty.
class EmptyValidator implements Validator {
  @override
  ValidationCallback? run(BuildContext context, String? newValue) {
    if (isNotEmpty(newValue)) {
      return null;
    }
    return (_) => L10n.get.lib.inputGenericRequired;
  }
}
