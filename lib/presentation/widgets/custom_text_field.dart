import 'package:flutter/material.dart';
import 'package:calculadora_polias/core/theme/app_theme.dart';

// Widget reutilizável para consistência nos formulários
class CustomTextField extends StatelessWidget {
  final String label;
  final String? suffixText;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final bool highlighted;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.suffixText,
    this.textInputAction = TextInputAction.next,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: textInputAction,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: highlighted ? AppTheme.primary : AppTheme.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffixText,
        fillColor: highlighted ? AppTheme.primarySoft : AppTheme.surface,
        suffixStyle: const TextStyle(color: AppTheme.textSecondary),
      ),
    );
  }
}
