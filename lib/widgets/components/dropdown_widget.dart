import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';

class DropdownWidget<T> extends StatelessWidget {
  const DropdownWidget({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValue,
    this.border,
    this.onChanged,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final ValueNotifier<T?> selectedValue;
  final InputBorder? border;
  final void Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedValue,
      builder: (context, value, __) {
        return DropdownButtonFormField<T>(
          decoration: AppStyle.baseInputDecoration(label),
          value: value,
          items: items,
          onChanged: (T? v) {
            selectedValue.value = v;

            if (onChanged != null) {
              onChanged!(v);
            }
          },
        );
      },
    );
  }
}

extension DropdownExtions<T> on List<T> {
  List<DropdownMenuItem<T>> toDropdownItems(String Function(T) labelBuilder) {
    return map(
      (e) => DropdownMenuItem(value: e, child: Text(labelBuilder(e))),
    ).toList();
  }
}
