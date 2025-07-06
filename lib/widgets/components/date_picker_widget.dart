import 'package:manage_applications/widgets/components/form_field_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({
    super.key,
    required this.label,
    required this.selectedDate,
    this.isDisabled = false,
  });

  final String label;
  final ValueNotifier<DateTime> selectedDate;
  final bool isDisabled;

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late final TextEditingController _controller;

  void _syncDate() {
    _controller.text = uiFormat.format(widget.selectedDate.value);
  }

  @override
  initState() {
    super.initState();
    _controller = TextEditingController(
      text: uiFormat.format(widget.selectedDate.value),
    );

    widget.selectedDate.addListener(_syncDate);
  }

  Future<void> changeDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate.value,
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime(2026, 1, 1),
    );
    if (picked != null && picked != widget.selectedDate.value) {
      widget.selectedDate.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.isDisabled
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.isDisabled ? null : () => changeDate(context),
        child: AbsorbPointer(
          child: FormFieldWidget(
            controller: _controller,
            label: widget.label,
            prefixIcon: const Icon(Icons.calendar_month),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.selectedDate.removeListener(_syncDate);
    _controller.dispose();
    super.dispose();
  }
}
