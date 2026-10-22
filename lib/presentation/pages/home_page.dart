import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        final content = _pages[_currentIndex];

        if (isDesktop) {
          return Scaffold(
            body: Column(
              children: [
                _buildDesktopNavbar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        content,
                        const SizedBox(height: 48),
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: content,
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BottomBannerAd(),
              NavigationBar(
                height: 64,
                selectedIndex: _currentIndex,
                onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Transmissão'),
                  NavigationDestination(icon: Icon(Icons.commit), label: 'Correia'),
                  NavigationDestination(icon: Icon(Icons.history), label: 'Histórico'),
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
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('assets/images/app_logo.png', height: 36),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Cálculo de RPM, Polias e Correias',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
          ),
          _navbarItem('Transmissão', 0),
          _navbarItem('Correia', 1),
          _navbarItem('Histórico', 2),
        ],
      ),
    );
  }

  Widget _navbarItem(String label, int index) {
    final bool isSelected = _currentIndex == index;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: TextButton(
        onPressed: () => setState(() => _currentIndex = index),
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? AppTheme.primarySoft : Colors.transparent,
          foregroundColor: isSelected ? AppTheme.primary : AppTheme.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 24,
        runSpacing: 8,
        children: [
          const Text('© 2026 ASCLABS', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          TextButton(
            onPressed: () => _launchURL('mailto:alefeasc@gmail.com'),
            child: const Text('alefeasc@gmail.com'),
          ),
          TextButton(
            onPressed: () => _launchURL('https://www.linkedin.com/in/alefealvessilva/'),
            child: const Text('LinkedIn'),
          ),
        ],
      ),
    );
  }
}
