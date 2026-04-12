import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calculadora_polias/core/theme/app_theme.dart';

class BrandingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;

  const BrandingAppBar({
    super.key,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset('assets/images/app_logo.png', height: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'CÁLCULO DE RPM. POLIAS E CORREIAS',
                style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.2,
                ),
              ),
              Row(
                children: [
                  Text(
                    'by ',
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      color: AppTheme.greyText,
                    ),
                  ),
                  Image.asset(
                    'assets/images/logo_asclabs.png',
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
