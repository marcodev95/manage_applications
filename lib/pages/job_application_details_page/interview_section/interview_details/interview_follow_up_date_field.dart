import 'package:manage_applications/widgets/components/date_picker_widget.dart';
import 'package:flutter/material.dart';

class InterviewFollowUpDateField extends StatefulWidget {
  const InterviewFollowUpDateField({
    super.key,
    required this.controller,
    required this.notifier,
  });

  final TextEditingController controller;
  final ValueNotifier<DateTime> notifier;

  @override
  State<InterviewFollowUpDateField> createState() =>
      _InterviewFollowUpDateFieldState();
}

class _InterviewFollowUpDateFieldState
    extends State<InterviewFollowUpDateField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        if (widget.controller.text.isEmpty) {
          widget.notifier.value = DateTime.now();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      maintainSize: false,
      visible: widget.controller.text.isNotEmpty,
      child: Expanded(
        child: DatePickerWidget(
          label: "Data invio del follow-up",
          selectedDate: widget.notifier,
        ),
      ),
    );
  }
}
