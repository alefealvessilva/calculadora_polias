import 'package:flutter/material.dart';
import 'package:calculadora_polias/l10n/l10n.dart';

// Widget reutilizável para consistência nos formulários
class CustomTextField extends StatelessWidget {
  final String label;
  final String? suffixText;
  final TextEditingController controller;
  final TextInputAction textInputAction;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.suffixText,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: textInputAction,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffixText,
          suffixStyle: const TextStyle(color: Colors.white54, fontWeight: FontWeight.normal),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return context.l10n.required;
          }
          if (double.tryParse(value.replaceAll(',', '.')) == null) {
            return context.l10n.invalidNumber;
          }
          return null;
        },
      ),
    );
  }
}
