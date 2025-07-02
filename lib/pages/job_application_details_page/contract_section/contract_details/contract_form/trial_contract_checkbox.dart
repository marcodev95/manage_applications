import 'package:flutter/material.dart';

class TrailContractCheckbox extends StatefulWidget {
  const TrailContractCheckbox(this.isTrialContractNotifier, {super.key});

  final ValueNotifier<bool> isTrialContractNotifier;

  @override
  State<TrailContractCheckbox> createState() => _TrailContractCheckboxState();
}

class _TrailContractCheckboxState extends State<TrailContractCheckbox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text('Contratto di prova'),
      value: widget.isTrialContractNotifier.value,
      onChanged: (bool? newValue) {
        if (newValue != null) {
          setState(() {
            widget.isTrialContractNotifier.value = newValue;
          });
        }
      },
    );
  }
}
