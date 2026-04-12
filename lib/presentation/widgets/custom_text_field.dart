import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.only(bottom: 16.0),
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
            return 'Obrigatório';
          }
          if (double.tryParse(value.replaceAll(',', '.')) == null) {
            return 'Número inválido';
          }
          return null;
        },
      ),
    );
  }
}
