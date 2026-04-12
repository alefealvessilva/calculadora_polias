import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calculadora_polias/core/ads/ad_helper.dart';
import 'package:calculadora_polias/core/theme/app_theme.dart';
import 'package:calculadora_polias/core/utils/unit_converter.dart';
import 'package:calculadora_polias/domain/usecases/calculations_usecases.dart';
import 'package:calculadora_polias/presentation/providers/app_providers.dart';
import 'package:calculadora_polias/core/widgets/disclaimer_widget.dart';
import 'package:calculadora_polias/core/utils/pdf_generator_service.dart';
import 'package:calculadora_polias/core/widgets/branding_app_bar.dart';
import 'package:calculadora_polias/presentation/widgets/custom_text_field.dart';
import 'package:calculadora_polias/presentation/widgets/pulley_system_diagram.dart';

class TransmissionPage extends ConsumerStatefulWidget {
  const TransmissionPage({super.key});

  @override
  ConsumerState<TransmissionPage> createState() => _TransmissionPageState();
}

class _TransmissionPageState extends ConsumerState<TransmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _n1Controller = TextEditingController();
  final _d1Controller = TextEditingController();
  final _n2Controller = TextEditingController();
  final _d2Controller = TextEditingController();

  DynamicTransmissionResult? _result;
  bool _isExporting = false;

  void _calculate() {
    FocusScope.of(context).unfocus();
    double? parseValue(String text) {
      if (text.trim().isEmpty) return null;
      return double.tryParse(text.replaceAll(',', '.'));
    }

    final n1 = parseValue(_n1Controller.text);
    final d1 = parseValue(_d1Controller.text);
    final n2 = parseValue(_n2Controller.text);
    final d2 = parseValue(_d2Controller.text);

    try {
      final result = CalculationsUsecases.calculateDynamicTransmission(
        n1: n1, d1: d1, n2: n2, d2: d2,
      );

      setState(() {
        _result = result;
        _n1Controller.text = UnitConverter.format(result.n1);
        _d1Controller.text = UnitConverter.format(result.d1);
        _n2Controller.text = UnitConverter.format(result.n2);
        _d2Controller.text = UnitConverter.format(result.d2);
      });

      final unit = ref.read(unitProvider);
      final item = HistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: CalculationType.transmission,
        title: 'Transmissão de Polias',
        result: 'N1:${UnitConverter.format(result.n1)} D1:${UnitConverter.format(result.d1)} -> N2:${UnitConverter.format(result.n2)} D2:${UnitConverter.format(result.d2)} ${unit.label}',
        date: DateTime.now(),
        calculationData: {
          'n1': result.n1, 'd1': result.d1, 'n2': result.n2, 'd2': result.d2, 'ratio': result.ratio,
        },
        unitLabel: unit.label,
      );
      ref.read(historyProvider.notifier).addHistoryItem(item);
      InterstitialAdManager.incrementAndMaybeShowAd();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('ArgumentError: ', '')), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _exportPdf() async {
    if (_result == null || _isExporting) return;

    setState(() => _isExporting = true);
    
    try {
      final unit = ref.read(unitProvider);
      await PdfGeneratorService.exportCalculation(
        title: 'Relatório de Transmissão',
        inputs: {
          'RPM Motor (N1)': '${UnitConverter.format(_result!.n1)} RPM',
          'Polia Motor (D1)': '${UnitConverter.format(_result!.d1)} ${unit.label}',
          'RPM Movida (N2)': '${UnitConverter.format(_result!.n2)} RPM',
          'Polia Movida (D2)': '${UnitConverter.format(_result!.d2)} ${unit.label}',
        },
        results: {
          'Relação de Transmissão': '1 : ${UnitConverter.format(_result!.ratio)}',
          'RPM de Saída': '${UnitConverter.format(_result!.n2)} RPM',
        },
        formulas: ['Fórmula Base: N1 * D1 = N2 * D2', 'Relação: i = D2 / D1'],
        diagramData: {'d1': _result!.d1, 'd2': _result!.d2, 'distance': 150.0},
      );
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  void _reset() {
    _n1Controller.clear(); _d1Controller.clear(); _n2Controller.clear(); _d2Controller.clear();
    setState(() { _result = null; });
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(unitProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        final content = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : 600),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isDesktop) ...[
                    const SizedBox(height: 80),
                    Text(
                      'Cálculo de Transmissão',
                      style: GoogleFonts.sora(fontSize: 48, fontWeight: FontWeight.w900, color: AppTheme.stellarWhite),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Dimensionamento de rotações e diâmetros para projetos mecânicos.',
                      style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 80),
                    _buildInfoBox(),
                    const SizedBox(height: 32),
                  ],

                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 1, child: _buildInputSection(unit)),
                        const SizedBox(width: 80),
                        Expanded(flex: 1, child: _buildVisualSection(unit)),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildInfoBox(),
                        const SizedBox(height: 32),
                        _buildInputSection(unit),
                        const SizedBox(height: 48),
                        _buildVisualSection(unit),
                      ],
                    ),
                  
                  if (isDesktop) const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      );

        if (isDesktop) return content;

        return Scaffold(
          appBar: const BrandingAppBar(),
          body: SingleChildScrollView(child: Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: content)),
        );
      },
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cosmicTeal.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cosmicTeal.withAlpha(20)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppTheme.cosmicTeal, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'DICA: Deixe o campo que deseja descobrir em BRANCO.',
              style: GoogleFonts.inter(color: AppTheme.cosmicTeal, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(MeasurementUnit unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MOTOR (Polia 1)', style: GoogleFonts.sora(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.stellarWhite)),
                  const SizedBox(height: 20),
                  CustomTextField(label: 'RPM Motor', controller: _n1Controller, suffixText: 'RPM'),
                  CustomTextField(label: 'Diâmetro (${unit.label})', controller: _d1Controller, suffixText: unit.label),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MOVIDA (Polia 2)', style: GoogleFonts.sora(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.stellarWhite)),
                  const SizedBox(height: 20),
                  CustomTextField(label: 'RPM Polia', controller: _n2Controller, suffixText: 'RPM'),
                  CustomTextField(label: 'Diâmetro (${unit.label})', controller: _d2Controller, suffixText: unit.label),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _reset,
                child: Text('LIMPAR CAMPOS', style: GoogleFonts.inter(color: AppTheme.greyText, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 2,
              child: Container(
                decoration: AppTheme.digitalGlowDecoration,
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text('CALCULAR'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVisualSection(MeasurementUnit unit) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: AppTheme.cardGlowDecoration,
      child: Column(
        children: [
          Text(
            'DIAGRAMA DE TRANSMISSÃO',
            style: GoogleFonts.sora(letterSpacing: 2, color: AppTheme.cosmicTeal, fontSize: 11, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 40),
          PulleySystemDiagram(
            n1: _result?.n1 ?? 0,
            d1: _result?.d1 ?? 0,
            n2: _result?.n2 ?? 0,
            d2: _result?.d2 ?? 0,
            animate: _result != null,
          ),
          if (_result != null) ...[
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Relação:', style: GoogleFonts.inter(color: AppTheme.greyText, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 12),
                  Text(
                    '1 : ${UnitConverter.format(_result!.ratio)}',
                    style: GoogleFonts.sora(color: AppTheme.cosmicTeal, fontSize: 24, fontWeight: FontWeight.w900, shadows: [
                      Shadow(color: AppTheme.cosmicTeal.withAlpha(50), blurRadius: 10),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isExporting ? null : _exportPdf,
                icon: _isExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.deepDark),
                        ),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(_isExporting ? 'GERANDO...' : 'GERAR RELATÓRIO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.stellarWhite,
                  foregroundColor: AppTheme.deepDark,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          const DisclaimerWidget(),
        ],
      ),
    );
  }
}
