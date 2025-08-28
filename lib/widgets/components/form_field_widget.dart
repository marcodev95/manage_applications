import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manage_applications/app_style.dart';

class FormFieldWidget extends StatelessWidget {
  const FormFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onTap,
    this.readOnly = false,
    this.hintText,
    this.maxLines,
    this.minLines,
    this.alignLabelWithHint,
    this.prefixIcon,
    this.isRequired = false,
    this.initialValue,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final bool readOnly;
  final String? hintText;
  final int? maxLines;
  final int? minLines;
  final bool? alignLabelWithHint;
  final Widget? prefixIcon;
  final bool isRequired;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: _buildDecoration(isRequired, label),
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      style: AppStyle.formField,
    );
  }
}

class RequiredFormFieldWidget extends StatelessWidget {
  const RequiredFormFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return FormFieldWidget(
      controller: controller,
      label: label,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: (String? v) => baseValidator(v, label),
      isRequired: true,
    );
  }
}

InputDecoration _buildDecoration(bool isRequired, String label) {
  final decoration = AppStyle.baseInputDecoration(label);

  if (!isRequired) return decoration;

  return decoration.copyWith(
    errorBorder: AppStyle.errorBorder,
    focusedErrorBorder: AppStyle.focusedErrorBorder,
    errorStyle: AppStyle.errorStyle,
  );
}

class DateFormFieldWidget extends StatelessWidget {
  const DateFormFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.onTap,
    this.readOnly = true,
  });

  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }
}

class ReadOnlyTextFormField extends StatelessWidget {
  const ReadOnlyTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final Widget suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: _buildDecoration(
        false,
        label,
      ).copyWith(suffixIcon: suffixIcon),
    );
  }
}

/// Validator

String? baseValidator(String? v, String label) {
  if (v == null || v.trim().isEmpty) {
    return "$label è obbligatorio!";
  } else {
    return null;
  }
}


/*Extra: evitare spostamenti di layout
Se il messaggio di errore è lungo, la form potrebbe “saltare” quando appare/scompare il testo.

Per evitarlo:

Usa helperText o un widget personalizzato che mantiene sempre lo spazio riservato per l’errore 
  (ad es. con SizedBox(height: 16) sotto il campo).

Oppure usa autovalidateMode per validare solo al submit o dopo il primo errore.


 */
