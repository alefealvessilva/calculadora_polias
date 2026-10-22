import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculadora_polias/core/theme/app_theme.dart';
import 'package:calculadora_polias/domain/usecases/calculations_usecases.dart';
import 'package:calculadora_polias/presentation/providers/app_providers.dart';
import 'package:calculadora_polias/core/utils/pdf_generator_service.dart';
import 'package:calculadora_polias/core/utils/unit_converter.dart';
import 'package:calculadora_polias/core/widgets/branding_app_bar.dart';
import 'package:intl/intl.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  String? _exportingItemId;

  IconData _getIconForType(CalculationType type) {
    switch (type) {
      case CalculationType.transmission:
        return Icons.settings_suggest;
      case CalculationType.beltLength:
        return Icons.linear_scale;
      case CalculationType.pulleySizing:
        return Icons.zoom_out_map;
    }
  }

  Future<void> _exportHistoryPdf(HistoryItem item) async {
    if (item.calculationData == null || _exportingItemId != null) return;
    
    setState(() => _exportingItemId = item.id);
    
    try {
      final data = item.calculationData!;
      final unit = item.unitLabel ?? 'mm';

      if (item.type == CalculationType.transmission) {
        await PdfGeneratorService.exportCalculation(
          title: 'Histórico: Transmissão',
          inputs: {
            'RPM Motor (N1)': '${UnitConverter.format(data['n1'])} RPM',
            'Polia Motor (D1)': '${UnitConverter.format(data['d1'])} $unit',
            'RPM Movida (N2)': '${UnitConverter.format(data['n2'])} RPM',
            'Polia Movida (D2)': '${UnitConverter.format(data['d2'])} $unit',
          },
          results: {
            'Relação de Transmissão': '1 : ${UnitConverter.format(data['ratio'] ?? 1.0)}',
            'RPM de Saída': '${UnitConverter.format(data['n2'])} RPM',
          },
          formulas: ['Fórmula Base: N1 * D1 = N2 * D2', 'Relação: i = D2 / D1'],
          diagramData: {'d1': (data['d1'] as num).toDouble(), 'd2': (data['d2'] as num).toDouble(), 'distance': 150.0},
        );
      } else if (item.type == CalculationType.beltLength) {
        await PdfGeneratorService.exportCalculation(
          title: 'Histórico: Correia',
          inputs: {
            'Polia Maior (D)': '${UnitConverter.format(data['d1'])} $unit',
            'Polia Menor (d)': '${UnitConverter.format(data['d2'])} $unit',
            'Distância Centros (C)': '${UnitConverter.format(data['c'])} $unit',
            'Comprimento (L)': '${UnitConverter.format(data['l'])} $unit',
          },
          results: {
            'Distância C': '${UnitConverter.format(data['c'])} $unit',
            'Comprimento L': '${UnitConverter.format(data['l'])} $unit',
          },
          formulas: [
            'L = 2C + 1.57(D + d) + (D - d)² / 4C',
            'C = [b + √(b² - 32(D - d)²)] / 16, onde b = 4L - 6.28(D + d)',
          ],
          diagramData: {'d1': (data['d1'] as num).toDouble(), 'd2': (data['d2'] as num).toDouble(), 'distance': (data['c'] as num).toDouble()},
        );
      }
    } finally {
      if (mounted) {
        setState(() => _exportingItemId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        final content = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 800 : 560),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 20),
              child: historyAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 96),
                      child: Center(
                        child: Text('Nenhum cálculo salvo ainda.', style: TextStyle(color: AppTheme.textSecondary)),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      if (isDesktop)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => ref.read(historyProvider.notifier).clearAll(),
                            icon: const Icon(Icons.delete_sweep_outlined),
                            label: const Text('Limpar tudo'),
                          ),
                        ),
                      for (final item in items) _buildItem(item),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Erro: $e', style: const TextStyle(color: Colors.redAccent))),
              ),
            ),
          ),
        );

        if (isDesktop) return content;

        return Scaffold(
          appBar: BrandingAppBar(
            title: 'Histórico',
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: () => ref.read(historyProvider.notifier).clearAll(),
                tooltip: 'Limpar tudo',
              ),
            ],
          ),
          body: SingleChildScrollView(child: content),
        );
      },
    );
  }

  Widget _buildItem(HistoryItem item) {
    final hasData = item.calculationData != null;
    final isExporting = _exportingItemId == item.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.card,
      child: Row(
        children: [
          Icon(_getIconForType(item.type), color: AppTheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(item.result, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4)),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(item.date),
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          if (hasData)
            isExporting
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : IconButton(
                    icon: const Icon(Icons.picture_as_pdf_outlined, color: AppTheme.primary),
                    onPressed: () => _exportHistoryPdf(item),
                    tooltip: 'Exportar PDF',
                  ),
        ],
      ),
    );
  }
}
