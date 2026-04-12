import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calculadora_polias/core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 20.0, end: 60.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Neon App
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.cosmicTeal.withAlpha(60),
                        blurRadius: _glowAnimation.value,
                        spreadRadius: _glowAnimation.value / 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
            
            // App Name
            Text(
              'Cálculo de RPM'.toUpperCase(),
              style: GoogleFonts.sora(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppTheme.stellarWhite,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Polias e Correias'.toUpperCase(),
              style: GoogleFonts.sora(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: AppTheme.stellarWhite.withAlpha(150),
                letterSpacing: 4,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Branding "by asclabs"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'by ',
                  style: GoogleFonts.inter(
                    color: AppTheme.greyText,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Image.asset(
                  'assets/images/logo_asclabs.png',
                  height: 24,
                  color: AppTheme.stellarWhite,
                ),
              ],
            ),
            
            const SizedBox(height: 80),
            
            // Loading
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.cosmicTeal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
