import 'package:adair_flutter_lib/res/dimen.dart';
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
        return _AutocompleteOptionsView<T>(
          onSelected: onSelected,
          options: options,
          displayStringForOption: widget.displayStringForOption,
          itemBuilder: widget.itemBuilder,
        );
      },
      fieldViewBuilder: _buildField,
      onSelected: (option) {
        _selectedOption = option;
        widget.onSelected(option);
      },
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

class _AutocompleteOptionsView<T extends Object> extends StatelessWidget {
  static const _maxHeight = 250.0;
  static const _elevation = 2.0;
  static const _outerBorderRadius = 16.0;
  static const _innerBorderRadius = 12.0;

  final AutocompleteOnSelected<T> onSelected;
  final Iterable<T> options;
  final AutocompleteOptionToString<T> displayStringForOption;
  final Widget Function(BuildContext context, T option)? itemBuilder;

  const _AutocompleteOptionsView({
    required this.onSelected,
    required this.options,
    required this.displayStringForOption,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: _elevation,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_outerBorderRadius)),
        ),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: _maxHeight),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);
              return Padding(
                padding: insetsTiny,
                child: InkWell(
                  onTap: () => onSelected(option),
                  borderRadius: BorderRadius.circular(_innerBorderRadius),
                  child: _buildItem(context, option),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, T option) {
    return itemBuilder?.call(context, option) ??
        Padding(
          padding: insetsDefault,
          child: Text(displayStringForOption(option)),
        );
  }
}
