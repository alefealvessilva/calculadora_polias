import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:calculadora_polias/core/ads/ad_helper.dart';
import 'package:calculadora_polias/core/theme/app_theme.dart';
import 'package:calculadora_polias/presentation/pages/calculator/belt_length_page.dart';
import 'package:calculadora_polias/presentation/pages/calculator/transmission_page.dart';
import 'package:calculadora_polias/presentation/pages/history_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  final List<Widget> _pages = [
    const TransmissionPage(),
    const BeltLengthPage(),
    const HistoryPage(),
  ];

  @override
  void initState() {
    super.initState();
    AdHelper.initGoogleMobileAds().then((value) {
      if (!kIsWeb) {
        InterstitialAdManager.loadInterstitialAd();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        // Conteúdo Principal
        final content = _pages[_currentIndex];

        if (isDesktop) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: Column(
              children: [
                // Navbar Superior (Site)
                _buildDesktopNavbar(),

                // Área de Conteúdo + Hero
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: content),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [_buildFooter()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Layout Mobile (App)
        return Scaffold(
          body: content,
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BottomBannerAd(),
              NavigationBar(
                height: 70,
                backgroundColor: AppTheme.surfaceColor,
                indicatorColor: AppTheme.cosmicTeal.withValues(alpha: 0.3),
                selectedIndex: _currentIndex,
                onDestinationSelected: (idx) {
                  setState(() => _currentIndex = idx);
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.settings),
                    label: 'Transmissão',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.commit),
                    label: 'Correia',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.history),
                    label: 'Histórico',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopNavbar() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      decoration: BoxDecoration(
        color: AppTheme.deepDark,
        border: const Border(bottom: BorderSide(color: Colors.white10)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cosmicTeal.withAlpha(15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo Neon App
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.cosmicTeal.withAlpha(30),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/images/app_logo.png', height: 52),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Cálculo de RPM. Polias e Correias'.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.sora(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppTheme.stellarWhite,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 1,
            height: 20,
            color: Colors.white12,
          ),
          const SizedBox(width: 12),
          // Autoria
          Row(
            children: [
              Text(
                'by ',
                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.greyText),
              ),
              Image.asset(
                'assets/images/logo_asclabs.png',
                height: 20,
                color: AppTheme.stellarWhite,
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Links de Navegação
          _navbarItem('Transmissão', 0),
          const SizedBox(width: 24),
          _navbarItem('Correias', 1),
          const SizedBox(width: 24),
          _navbarItem('Histórico', 2),
        ],
      ),
    );
  }

  Widget _navbarItem(String label, int index) {
    bool isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.cosmicTeal.withAlpha(20) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.cosmicTeal.withAlpha(100) : Colors.transparent,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            color: isSelected ? AppTheme.cosmicTeal : AppTheme.greyText,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 48),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Coluna Brand
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.cosmicTeal.withAlpha(20),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/images/app_logo.png', height: 50),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CÁLCULO DE RPM',
                                  style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.stellarWhite),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'by ',
                                      style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 13),
                                    ),
                                    Image.asset(
                                      'assets/images/logo_asclabs.png',
                                      height: 20,
                                      color: AppTheme.stellarWhite,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Laboratório de Soluções Digitais',
                          style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 60),
                  // Coluna Links
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CÁLCULOS', style: GoogleFonts.sora(color: AppTheme.stellarWhite, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5)),
                        const SizedBox(height: 16),
                        _footerLink('Transmissão'),
                        _footerLink('Comprimento'),
                      ],
                    ),
                  ),
                  // Coluna Contato
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CONTATO', style: GoogleFonts.sora(color: AppTheme.stellarWhite, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5)),
                        const SizedBox(height: 16),
                        _footerLink('alefeasc@gmail.com', onTap: () => _launchURL('mailto:alefeasc@gmail.com')),
                        const SizedBox(height: 8),
                        _linkedinButton(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Divider(color: Colors.white10),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '© 2026 ASCLABS - Laboratório de Soluções Digitais',
                    style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 11),
                  ),
                  Expanded(
                    child: Text(
                      'Desenvolvido para engenharia mecânica de precisão.',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.inter(color: Colors.white24, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _linkedinButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchURL('https://www.linkedin.com/in/alefealvessilva/'),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0077B5).withAlpha(30),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF0077B5).withAlpha(100)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.link, color: Color(0xFF00E5FF), size: 14),
              const SizedBox(width: 8),
              Text(
                'LINKEDIN',
                style: GoogleFonts.sora(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerLink(String label, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 12),
        ),
      ),
    );
  }
}
