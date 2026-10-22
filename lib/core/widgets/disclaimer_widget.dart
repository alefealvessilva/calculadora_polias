import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DisclaimerWidget extends StatelessWidget {
  const DisclaimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Resultados teóricos. A verificação por um engenheiro responsável é necessária antes da aplicação física.',
      textAlign: TextAlign.center,
      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.5),
    );
  }
}
