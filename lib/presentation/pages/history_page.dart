import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:calculadora_polias/core/ads/export_gate.dart';
import 'package:calculadora_polias/core/theme/app_theme.dart';
import 'package:calculadora_polias/core/utils/pdf_generator_service.dart';
import 'package:calculadora_polias/core/utils/unit_converter.dart';
import 'package:calculadora_polias/domain/usecases/calculations_usecases.dart';
import 'package:calculadora_polias/l10n/l10n.dart';
import 'package:calculadora_polias/presentation/providers/app_providers.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  String? _exportingItemId;

  String _title(HistoryItem item) {
    final l10n = context.l10n;
    switch (item.type) {
      case CalculationType.transmission:
        return l10n.historyTransmissionTitle;
      case CalculationType.beltLength:
        return l10n.historyBeltTitle;
      case CalculationType.pulleySizing:
        return item.title;
    }
  }

  /// Resumo montado a partir dos números salvos, para respeitar o idioma atual.
  String _summary(HistoryItem item) {
    final d = item.calculationData;
    if (d == null) return item.result;
    String f(String k) => UnitConverter.format((d[k] as num).toDouble());
    final u = item.unitLabel ?? 'mm';
    if (item.type == CalculationType.transmission) {
      return 'N1 ${f('n1')} · D1 ${f('d1')} → N2 ${f('n2')} · D2 ${f('d2')} ($u)';
    }
    return 'D ${f('d1')} · d ${f('d2')} → C ${f('c')} · L ${f('l')} ($u)';
  }

  Future<void> _export(HistoryItem item) async {
    final data = item.calculationData;
    if (data == null || _exportingItemId != null) return;
    await runWithRewardedGate(context, () => _doExport(item));
  }

  Future<void> _doExport(HistoryItem item) async {
    final data = item.calculationData!;
    if (!mounted) return;
    final l10n = context.l10n;
    final unit = item.unitLabel ?? 'mm';
    String f(String k) => UnitConverter.format((data[k] as num).toDouble());

    setState(() => _exportingItemId = item.id);
    try {
      if (item.type == CalculationType.transmission) {
        await PdfGeneratorService.exportCalculation(
          labels: l10n.pdfLabels(),
          title: l10n.pdfTitleHistoryTransmission,
          inputs: {
            l10n.pdfMotorRpm: '${f('n1')} RPM',
            l10n.pdfMotorPulley: '${f('d1')} $unit',
            l10n.pdfDrivenRpm: '${f('n2')} RPM',
            l10n.pdfDrivenPulley: '${f('d2')} $unit',
          },
          results: {
            l10n.pdfRatio: '1 : ${UnitConverter.format((data['ratio'] as num? ?? 1).toDouble())}',
            l10n.pdfOutputRpm: '${f('n2')} RPM',
          },
          formulas: [l10n.pdfBaseFormula, l10n.pdfRatioFormula],
          diagramData: {
            'd1': (data['d1'] as num).toDouble(),
            'd2': (data['d2'] as num).toDouble(),
            'distance': 150.0,
          },
        );
      } else if (item.type == CalculationType.beltLength) {
        await PdfGeneratorService.exportCalculation(
          labels: l10n.pdfLabels(),
          title: l10n.pdfTitleHistoryBelt,
          inputs: {
            l10n.pdfLargePulley: '${f('d1')} $unit',
            l10n.pdfSmallPulley: '${f('d2')} $unit',
            l10n.pdfCenterDistance: '${f('c')} $unit',
            l10n.pdfBeltLength: '${f('l')} $unit',
          },
          results: {
            l10n.pdfResultDistance: '${f('c')} $unit',
            l10n.pdfResultLength: '${f('l')} $unit',
          },
          formulas: [
            'L = 2C + 1.57(D + d) + (D - d)² / 4C',
            'C = [b + √(b² - 32(D - d)²)] / 16, b = 4L - 6.28(D + d)',
          ],
          diagramData: {
            'd1': (data['d1'] as num).toDouble(),
            'd2': (data['d2'] as num).toDouble(),
            'distance': (data['c'] as num).toDouble(),
          },
        );
      }
    } finally {
      if (mounted) setState(() => _exportingItemId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final history = ref.watch(historyProvider);
    final locale = Localizations.localeOf(context).toString();

    return history.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Text(
              l10n.historyEmpty,
              style: const TextStyle(color: AppTheme.textMuted),
            ),
          );
        }
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              itemCount: items.length + 1,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () =>
                          ref.read(historyProvider.notifier).clearAll(),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: Text(l10n.historyClear),
                    ),
                  );
                }
                final item = items[i - 1];
                final exporting = _exportingItemId == item.id;
                return Card(
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(
                      _title(item),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${_summary(item)}\n${DateFormat.yMd(locale).add_Hm().format(item.date)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ),
                    isThreeLine: true,
                    trailing: item.calculationData == null
                        ? null
                        : exporting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : IconButton(
                                tooltip: l10n.exportPdf,
                                icon: const Icon(Icons.picture_as_pdf_outlined),
                                onPressed: () => _export(item),
                              ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
