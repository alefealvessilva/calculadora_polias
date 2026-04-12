import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class DisclaimerWidget extends StatelessWidget {
  const DisclaimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'AVISO TÉCNICO',
                style: GoogleFonts.sora(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.greyText,
                  letterSpacing: 2,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Os resultados apresentados são cálculos teóricos fundamentados em normas de engenharia. A verificação técnica por um engenheiro mecânico responsável é mandatória para a implementação física segura.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.greyText.withAlpha(180),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
