import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    super.key,
    required this.label,
    required this.selectedDate,
  });

  final String label;
  final ValueNotifier<DateTime> selectedDate;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker(
      initialDate: widget.selectedDate.value,
      firstDate: DateTime(2025),
      lastDate: DateTime(2101),
      onDateChanged: (date) => widget.selectedDate.value = date,
    );
  }
}
