import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/widgets/components/form_field_widget.dart';

class InterviewNoteSection extends StatelessWidget {
  final TextEditingController controller;

  const InterviewNoteSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note sul colloquio',
          style: TextStyle(
            fontSize: AppStyle.tableTextFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        FormFieldWidget(
          controller: controller,
          label: '',
          minLines: 4,
          maxLines: null,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
