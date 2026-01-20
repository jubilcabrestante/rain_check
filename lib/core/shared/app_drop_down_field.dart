import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String Function(T) optionLabel;
  final String? Function(T?)? validator;

  const AppDropdownField({
    super.key,
    required this.title,
    required this.options,
    required this.value,
    required this.onChanged,
    required this.optionLabel,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$title :",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: DropdownButtonFormField<T>(
            // value: value,
            onChanged: onChanged,
            items: options.map((T option) {
              return DropdownMenuItem<T>(
                value: option,
                child: Text(
                  optionLabel(option),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }).toList(),
            hint: Text(
              "Select here",
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 8),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
