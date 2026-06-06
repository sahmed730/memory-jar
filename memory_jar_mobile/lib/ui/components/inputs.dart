import 'package:flutter/material.dart';

class MemoryTextField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const MemoryTextField({
    super.key,
    required this.label,
    this.placeholder,
    this.maxLines = 1,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
      ),
    );
  }
}

class MemoryChoiceChips<T> extends StatelessWidget {
  final List<T> options;
  final T selectedOption;
  final String Function(T) labelBuilder;
  final void Function(T) onSelected;

  const MemoryChoiceChips({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: options.map((option) {
        final isSelected = option == selectedOption;
        return ChoiceChip(
          label: Text(labelBuilder(option)),
          selected: isSelected,
          onSelected: (_) => onSelected(option),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: isSelected ? BorderSide.none : BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          backgroundColor: Colors.transparent,
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          labelStyle: isSelected
              ? Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)
              : Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        );
      }).toList(),
    );
  }
}
