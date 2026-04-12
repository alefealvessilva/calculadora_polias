import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
            constraints: BoxConstraints(maxWidth: isDesktop ? 1000 : 800),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 16),
              child: historyAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 120),
                      child: Center(child: Text('Nenhum registro encontrado.', style: GoogleFonts.inter(color: AppTheme.greyText))),
                    );
                  }
                  return Column(
                    children: [
                      if (isDesktop) ...[
                        const SizedBox(height: 80),
                        Text(
                          'Histórico de Cálculos',
                          style: GoogleFonts.sora(fontSize: 48, fontWeight: FontWeight.w900, color: AppTheme.stellarWhite),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Visualize e gere relatórios de seus dimensionamentos salvos.',
                          style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 64),
                      ],
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final hasData = item.calculationData != null;
                          final isThisItemExporting = _exportingItemId == item.id;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Ícone
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: AppTheme.cosmicTeal.withAlpha(20), shape: BoxShape.circle),
                                    child: Icon(_getIconForType(item.type), color: AppTheme.cosmicTeal, size: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  // Conteúdo
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title, 
                                          style: GoogleFonts.sora(fontWeight: FontWeight.w800, color: AppTheme.stellarWhite, fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.result, 
                                          style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 12, height: 1.4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Ações e Data
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (hasData)
                                        isThisItemExporting
                                            ? const SizedBox(
                                                width: 32,
                                                height: 32,
                                                child: Padding(
                                                  padding: EdgeInsets.all(6),
                                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.cosmicTeal),
                                                ),
                                              )
                                            : IconButton(
                                                constraints: const BoxConstraints(),
                                                padding: EdgeInsets.zero,
                                                icon: const Icon(Icons.picture_as_pdf_outlined, color: AppTheme.cosmicTeal, size: 28),
                                                onPressed: () => _exportHistoryPdf(item),
                                                tooltip: 'Exportar PDF',
                                              ),
                                      const SizedBox(height: 12),
                                      Text(
                                        DateFormat('dd MMM\nHH:mm').format(item.date).toUpperCase(),
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.inter(fontSize: 10, color: AppTheme.greyText.withAlpha(150), fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      if (isDesktop) const SizedBox(height: 120),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.cosmicTeal)),
                error: (e, _) => Center(child: Text('Erro: $e', style: const TextStyle(color: Colors.redAccent))),
              ),
            ),
          ),
        );

        if (isDesktop) return content;

        return Scaffold(
          appBar: BrandingAppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined, color: AppTheme.cosmicTeal),
                onPressed: () => ref.read(historyProvider.notifier).clearAll(),
                tooltip: 'Limpar Tudo',
              )
            ],
          ),
          body: SingleChildScrollView(child: Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: content)),
        );
      },
    );
  }
}
