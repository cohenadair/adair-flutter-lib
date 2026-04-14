import 'package:adair_flutter_lib/widgets/dropdown_options_view.dart';
import 'package:flutter/material.dart';

/// A text field that wraps Flutter's [Autocomplete] widget with a consistent
/// M3-styled dropdown container.
class AutocompleteTextInput<T extends Object> extends StatefulWidget {
  /// Called on every keystroke; returns the matching options.
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// Converts an option to the string shown in the text field when an option
  /// is selected.
  final AutocompleteOptionToString<T> displayStringForOption;

  /// Called with the selected option, or null when the user clears/changes
  /// the text after a selection.
  final ValueChanged<T?> onSelected;

  /// Optional builder for each option row in the dropdown. If null, options
  /// are displayed as plain [Text] via [displayStringForOption].
  final Widget Function(BuildContext context, T option)? itemBuilder;

  final String? label;
  final FocusNode? focusNode;

  const AutocompleteTextInput({
    super.key,
    required this.optionsBuilder,
    required this.displayStringForOption,
    required this.onSelected,
    this.itemBuilder,
    this.label,
    this.focusNode,
  });

  @override
  State<AutocompleteTextInput<T>> createState() =>
      _AutocompleteTextInputState<T>();
}

class _AutocompleteTextInputState<T extends Object>
    extends State<AutocompleteTextInput<T>> {
  T? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      optionsBuilder: widget.optionsBuilder,
      displayStringForOption: widget.displayStringForOption,
      optionsViewBuilder: (_, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: DropdownOptionsView(
            children: options
                .map((option) => _buildOptionItem(context, option, onSelected))
                .toList(),
          ),
        );
      },
      fieldViewBuilder: _buildField,
      onSelected: (option) {
        _selectedOption = option;
        widget.onSelected(option);
      },
    );
  }

  Widget _buildOptionItem(
    BuildContext context,
    T option,
    AutocompleteOnSelected<T> onSelected,
  ) {
    return DropdownOptionItem(
      onTap: () => onSelected(option),
      child:
          widget.itemBuilder?.call(context, option) ??
          Text(widget.displayStringForOption(option)),
    );
  }

  Widget _buildField(
    BuildContext _,
    TextEditingController textController,
    FocusNode autocompleteFocusNode,
    VoidCallback _,
  ) {
    return TextFormField(
      controller: textController,
      focusNode: widget.focusNode ?? autocompleteFocusNode,
      decoration: InputDecoration(labelText: widget.label),
      onChanged: (value) {
        if (_selectedOption != null &&
            value != widget.displayStringForOption(_selectedOption as T)) {
          _selectedOption = null;
          widget.onSelected(null);
        }
      },
    );
  }
}
