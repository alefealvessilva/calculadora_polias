import 'package:flutter/material.dart';
import 'package:calculadora_polias/core/ads/ad_helper.dart';
import 'package:calculadora_polias/l10n/l10n.dart';

/// Exporta direto quando não há anúncio disponível (web, sem ID ou sem
/// preenchimento). Caso contrário pede confirmação e exige o anúncio premiado.
Future<void> runWithRewardedGate(
  BuildContext context,
  Future<void> Function() export,
) async {
  if (!RewardedGate.ready) {
    RewardedGate.load();
    return export();
  }

  final l10n = context.l10n;
  final watch = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.rewardedTitle),
      content: Text(l10n.rewardedBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.rewardedWatch),
        ),
      ],
    ),
  );
  if (watch != true) return;

  final earned = await RewardedGate.show();
  if (earned) await export();
}
