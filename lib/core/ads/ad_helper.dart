import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// IDs vêm do .env (ADMOB_INTERSTITIAL_ID, ADMOB_REWARDED_ID).
/// Sem ID configurado o formato correspondente simplesmente não aparece.
class AdHelper {
  static String _id(String key) => dotenv.maybeGet(key) ?? '';

  static String get interstitialId => _id('ADMOB_INTERSTITIAL_ID');
  static String get rewardedId => _id('ADMOB_REWARDED_ID');

  static bool get supported => !kIsWeb;
  static bool get interstitialEnabled => supported && interstitialId.isNotEmpty;
  static bool get rewardedEnabled => supported && rewardedId.isNotEmpty;

  static bool _initialized = false;

  /// Consentimento (UMP) e depois o SDK. Seguro chamar mais de uma vez.
  static Future<void> init() async {
    if (!supported || _initialized) return;
    if (!interstitialEnabled && !rewardedEnabled) return;
    _initialized = true;

    try {
      final done = Completer<void>();
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () async {
          try {
            await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
          } catch (e) {
            debugPrint('UMP form: $e');
          }
          if (!done.isCompleted) done.complete();
        },
        (error) {
          debugPrint('UMP: ${error.message}');
          if (!done.isCompleted) done.complete();
        },
      );
      await done.future.timeout(const Duration(seconds: 10), onTimeout: () {});

      if (await ConsentInformation.instance.canRequestAds()) {
        await MobileAds.instance.initialize();
        InterstitialAdManager.load();
        RewardedGate.load();
      }
    } catch (e) {
      debugPrint('Ads init: $e');
    }
  }
}

/// Intersticial discreto: nunca nos primeiros usos e a cada [_every] cálculos.
class InterstitialAdManager {
  static InterstitialAd? _ad;
  static int _count = 0;
  static const int _grace = 3;
  static const int _every = 4;
  static const String _prefKey = 'interstitial_calc_count';

  static Future<void> initCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _count = prefs.getInt(_prefKey) ?? 0;
    } catch (e) {
      debugPrint('initCount: $e');
    }
  }

  static void load() {
    if (!AdHelper.interstitialEnabled || _ad != null) return;
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _ad = ad,
        onAdFailedToLoad: (e) => debugPrint('Interstitial: ${e.message}'),
      ),
    );
  }

  static Future<void> incrementAndMaybeShowAd() async {
    _count++;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefKey, _count);
    } catch (_) {}

    if (!AdHelper.interstitialEnabled) return;
    if (_count <= _grace || _count % _every != 0) return;

    final ad = _ad;
    if (ad == null) {
      load();
      return;
    }
    _ad = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        load();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        load();
      },
    );
    ad.show();
  }
}

/// Anúncio premiado para liberar a exportação de PDF.
class RewardedGate {
  static RewardedAd? _ad;

  static bool get ready => _ad != null;

  static void load() {
    if (!AdHelper.rewardedEnabled || _ad != null) return;
    RewardedAd.load(
      adUnitId: AdHelper.rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _ad = ad,
        onAdFailedToLoad: (e) => debugPrint('Rewarded: ${e.message}'),
      ),
    );
  }

  /// Mostra o anúncio e devolve true se o usuário ganhou a recompensa.
  static Future<bool> show() async {
    final ad = _ad;
    if (ad == null) return false;
    _ad = null;
    final completer = Completer<bool>();
    var rewarded = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        load();
        if (!completer.isCompleted) completer.complete(rewarded);
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        load();
        if (!completer.isCompleted) completer.complete(false);
      },
    );
    ad.show(onUserEarnedReward: (view, reward) => rewarded = true);
    return completer.future;
  }
}
