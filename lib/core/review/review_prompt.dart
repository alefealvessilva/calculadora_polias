import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pede avaliação na loja após cálculos bem-sucedidos, sem incomodar:
/// só no Android/iOS, no 3º e no 10º cálculo (a Play ainda limita a exibição).
class ReviewPrompt {
  static const _countKey = 'review_calc_count';
  static const _askAt = {3, 10};

  static Future<void> onCalculationSuccess() async {
    if (kIsWeb) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final count = (prefs.getInt(_countKey) ?? 0) + 1;
      await prefs.setInt(_countKey, count);
      if (!_askAt.contains(count)) return;

      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        // Dá tempo do usuário ver o resultado antes do diálogo.
        await Future<void>.delayed(const Duration(seconds: 2));
        await review.requestReview();
      }
    } catch (e) {
      debugPrint('ReviewPrompt: $e');
    }
  }
}
