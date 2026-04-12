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
import 'package:calculadora_polias/presentation/widgets/pulley_diagram_painter.dart';

class BeltLengthPage extends ConsumerStatefulWidget {
  const BeltLengthPage({super.key});

  @override
  ConsumerState<BeltLengthPage> createState() => _BeltLengthPageState();
}

class _BeltLengthPageState extends ConsumerState<BeltLengthPage> {
  final _formKey = GlobalKey<FormState>();
  final _d1Controller = TextEditingController();
  final _d2Controller = TextEditingController();
  final _cController = TextEditingController();
  final _lController = TextEditingController();

  BeltDynamicResult? _result;
  bool _isExporting = false;

  void _calculate() {
    FocusScope.of(context).unfocus();
    double? parseValue(String text) {
      if (text.trim().isEmpty) return null;
      return double.tryParse(text.replaceAll(',', '.'));
    }

    final d1 = parseValue(_d1Controller.text);
    final d2 = parseValue(_d2Controller.text);
    final c = parseValue(_cController.text);
    final l = parseValue(_lController.text);

    try {
      final result = CalculationsUsecases.calculateDynamicBeltLength(
        d1: d1,
        d2: d2,
        c: c,
        l: l,
      );

      setState(() {
        _result = result;
        _d1Controller.text = UnitConverter.format(result.d1);
        _d2Controller.text = UnitConverter.format(result.d2);
        _cController.text = UnitConverter.format(result.c);
        _lController.text = UnitConverter.format(result.l);
      });

      final unit = ref.read(unitProvider);
      final item = HistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: CalculationType.beltLength,
        title: 'Comprimento de Correia',
        result:
            'D:${UnitConverter.format(result.d1)} d:${UnitConverter.format(result.d2)} -> C:${UnitConverter.format(result.c)} L:${UnitConverter.format(result.l)} ${unit.label}',
        date: DateTime.now(),
        calculationData: {
          'd1': result.d1,
          'd2': result.d2,
          'c': result.c,
          'l': result.l,
        },
        unitLabel: unit.label,
      );
      ref.read(historyProvider.notifier).addHistoryItem(item);
      InterstitialAdManager.incrementAndMaybeShowAd();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('ArgumentError: ', '')),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _exportPdf() async {
    if (_result == null || _isExporting) return;

    setState(() => _isExporting = true);

    try {
      final unit = ref.read(unitProvider);
      await PdfGeneratorService.exportCalculation(
        title: 'Relatório de Correia',
        inputs: {
          'Polia Maior (D)':
              '${UnitConverter.format(_result!.d1)} ${unit.label}',
          'Polia Menor (d)':
              '${UnitConverter.format(_result!.d2)} ${unit.label}',
          'Distância entre Centros (C)':
              '${UnitConverter.format(_result!.c)} ${unit.label}',
          'Comprimento da Correia (L)':
              '${UnitConverter.format(_result!.l)} ${unit.label}',
        },
        results: {
          'Distância C': '${UnitConverter.format(_result!.c)} ${unit.label}',
          'Comprimento L': '${UnitConverter.format(_result!.l)} ${unit.label}',
        },
        formulas: [
          'L = 2C + 1.57(D + d) + (D - d)² / 4C',
          'C = [b + √(b² - 32(D - d)²)] / 16, onde b = 4L - 6.28(D + d)',
        ],
        diagramData: {
          'd1': _result!.d1,
          'd2': _result!.d2,
          'distance': _result!.c,
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  void _reset() {
    _d1Controller.clear();
    _d2Controller.clear();
    _cController.clear();
    _lController.clear();
    setState(() {
      _result = null;
    });
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
                        'Cálculo de Correias',
                        style: GoogleFonts.sora(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.stellarWhite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Determine o comprimento exato ou a distância entre centros de forma simples.',
                        style: GoogleFonts.inter(
                          color: AppTheme.greyText,
                          fontSize: 18,
                        ),
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
          body: SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: content),
          ),
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
              style: GoogleFonts.inter(
                color: AppTheme.cosmicTeal,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
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
                  Text(
                    'DIÂMETROS',
                    style: GoogleFonts.sora(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppTheme.stellarWhite,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Polia Maior (${unit.label})',
                    controller: _d1Controller,
                    suffixText: unit.label,
                  ),
                  CustomTextField(
                    label: 'Polia Menor (${unit.label})',
                    controller: _d2Controller,
                    suffixText: unit.label,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GEOMETRIA',
                    style: GoogleFonts.sora(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppTheme.stellarWhite,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Dist. Centros (${unit.label})',
                    controller: _cController,
                    suffixText: unit.label,
                  ),
                  CustomTextField(
                    label: 'Comprimento (${unit.label})',
                    controller: _lController,
                    suffixText: unit.label,
                  ),
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
                child: Text(
                  'LIMPAR CAMPOS',
                  style: GoogleFonts.inter(
                    color: AppTheme.greyText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            'DIAGRAMA GEOMÉTRICO',
            style: GoogleFonts.sora(
              letterSpacing: 2,
              color: AppTheme.cosmicTeal,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: AnimatedPulleyDiagram(
              drivingDiameter: _result?.d1 ?? 50,
              drivenDiameter: _result?.d2 ?? 50,
              distance: _result?.c ?? 100,
              animate: _result != null,
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: 40),
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.deepDark,
                          ),
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
