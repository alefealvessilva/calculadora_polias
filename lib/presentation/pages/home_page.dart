import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:calculadora_polias/core/ads/ad_helper.dart';
import 'package:calculadora_polias/core/theme/app_theme.dart';
import 'package:calculadora_polias/l10n/l10n.dart';
import 'package:calculadora_polias/presentation/pages/calculator/belt_length_page.dart';
import 'package:calculadora_polias/presentation/pages/calculator/transmission_page.dart';
import 'package:calculadora_polias/presentation/pages/history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  // IndexedStack mantém os campos preenchidos ao trocar de aba.
  static const _pages = [TransmissionPage(), BeltLengthPage(), HistoryPage()];

  @override
  void initState() {
    super.initState();
    // Anúncios iniciam depois do primeiro frame; não atrasam a abertura.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await InterstitialAdManager.initCount();
      await AdHelper.init();
    });
  }

  Future<void> _open(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final wide = MediaQuery.sizeOf(context).width >= 720;
    final labels = [l10n.tabTransmission, l10n.tabBelt, l10n.tabHistory];
    const icons = [Icons.settings_outlined, Icons.linear_scale, Icons.history];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset('assets/images/app_logo.png', height: 28),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                l10n.appTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        actions: [
          if (wide)
            for (var i = 0; i < labels.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: TextButton(
                  onPressed: () => setState(() => _index = i),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        i == _index ? AppTheme.accent : AppTheme.textMuted,
                  ),
                  child: Text(labels[i]),
                ),
              ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              top: false,
              child: IndexedStack(index: _index, children: _pages),
            ),
          ),
          if (wide) _Footer(onEmail: () => _open('mailto:alefeasc@gmail.com')),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: [
                for (var i = 0; i < labels.length; i++)
                  NavigationDestination(icon: Icon(icons[i]), label: labels[i]),
              ],
            ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onEmail;
  const _Footer({required this.onEmail});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          const Text(
            '© 2026 ASCLABS',
            style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
          TextButton(
            onPressed: onEmail,
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 32),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: Text(l10n.footerContact),
          ),
        ],
      ),
    );
  }
}
