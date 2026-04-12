import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdHelper {
  static bool get adsEnabled {
    final bannerId = dotenv.maybeGet('ADMOB_BANNER_ID');
    final interstitialId = dotenv.maybeGet('ADMOB_INTERSTITIAL_ID');
    return bannerId != null && bannerId.isNotEmpty && 
           interstitialId != null && interstitialId.isNotEmpty;
  }

  static String get bannerAdUnitId {
    return dotenv.get('ADMOB_BANNER_ID', fallback: '');
  }

  static String get interstitialAdUnitId {
    return dotenv.get('ADMOB_INTERSTITIAL_ID', fallback: '');
  }

  static Future<void> initGoogleMobileAds() async {
    if (kIsWeb) {
      await InterstitialAdManager.initCount();
      return;
    }

    if (adsEnabled) {
      try {
        await MobileAds.instance.initialize();
      } catch (e) {
        debugPrint('Erro ao inicializar MobileAds: $e');
      }
    }
    
    await InterstitialAdManager.initCount();
  }
}

// Widget Placeholder para o Banner Ad
class BottomBannerAd extends StatefulWidget {
  const BottomBannerAd({super.key});

  @override
  State<BottomBannerAd> createState() => _BottomBannerAdState();
}

class _BottomBannerAdState extends State<BottomBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && AdHelper.adsEnabled) {
      _loadAd();
    }
  }

  void _loadAd() {
    final adUnitId = AdHelper.bannerAdUnitId;
    if (adUnitId.isEmpty) return;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _isLoaded = true);
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !AdHelper.adsEnabled) return const SizedBox.shrink();
    if (_isLoaded && _bannerAd != null) {
      return Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return const SizedBox(height: 50);
  }
}

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;
  static int _calculationCount = 0;
  static const int _adFrequency = 3;
  static const String _prefKey = 'interstitial_calc_count';

  static int get calculationsUntilNextAd {
    return _adFrequency - (_calculationCount % _adFrequency);
  }

  static Future<void> initCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _calculationCount = prefs.getInt(_prefKey) ?? 0;
      
      if (!kIsWeb && AdHelper.adsEnabled) {
        loadInterstitialAd();
      }
    } catch (e) {
      debugPrint('Error init count: $e');
    }
  }

  static void loadInterstitialAd() {
    if (kIsWeb || !AdHelper.adsEnabled) return;
    
    final adUnitId = AdHelper.interstitialAdUnitId;
    if (adUnitId.isEmpty) return;

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  static void incrementAndMaybeShowAd() async {
    _calculationCount++;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefKey, _calculationCount);
    } catch (e) {
      debugPrint('Não foi possivel salvar prefs $e');
    }

    if (kIsWeb || !AdHelper.adsEnabled) return;

    if (_calculationCount % _adFrequency == 0) {
      if (_interstitialAd != null) {
        _interstitialAd!.show();
        _interstitialAd = null;
        loadInterstitialAd();
      } else {
        debugPrint('Interstitial ad not ready yet.');
        loadInterstitialAd(); // Tenta carregar se não estiver pronto
      }
    }
  }
}
