import 'package:manage_applications/widgets/components/form_field_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({
    super.key,
    required this.label,
    required this.selectedTime,
  });

  final String label;
  final ValueNotifier<TimeOfDay> selectedTime;

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: fromTimeOfDayToString(widget.selectedTime.value),
    );

    widget.selectedTime.addListener(_syncTime);
  }

  void _syncTime() {
    _controller.text = fromTimeOfDayToString(widget.selectedTime.value);
  }

  Future<void> changeTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime.value,
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );

    if (picked != null && picked != widget.selectedTime.value) {
      widget.selectedTime.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => changeTime(context),
        child: AbsorbPointer(
          child: FormFieldWidget(
            controller: _controller,
            label: widget.label,
            readOnly: true,
            validator: (String? v) => baseValidator(v, widget.label),
            prefixIcon: const Icon(Icons.access_time),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.selectedTime.removeListener(_syncTime);
    _controller.dispose();
    super.dispose();
  }
}
