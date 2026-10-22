import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:calculadora_polias/presentation/widgets/result_card.dart';

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
  String? _solved; // campo que foi deixado em branco e calculado
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

    final solved = d1 == null ? 'd1' : d2 == null ? 'd2' : c == null ? 'c' : 'l';

    try {
      final result = CalculationsUsecases.calculateDynamicBeltLength(
        d1: d1,
        d2: d2,
        c: c,
        l: l,
      );

      setState(() {
        _result = result;
        _solved = solved;
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
      _solved = null;
    });
  }

  ({String label, String value}) _solvedInfo(MeasurementUnit unit) {
    final r = _result!;
    String v(double x) => '${UnitConverter.format(x)} ${unit.label}';
    switch (_solved) {
      case 'd1':
        return (label: 'Diâmetro da polia maior', value: v(r.d1));
      case 'd2':
        return (label: 'Diâmetro da polia menor', value: v(r.d2));
      case 'c':
        return (label: 'Distância entre centros', value: v(r.c));
      default:
        return (label: 'Comprimento da correia', value: v(r.l));
    }
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(unitProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        final inputs = _buildInputSection(unit);
        final results = _result == null ? const SizedBox.shrink() : _buildResultSection(unit);

        final content = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1000 : 560),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 20),
              child: Form(
                key: _formKey,
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: inputs),
                          const SizedBox(width: 32),
                          Expanded(child: results),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [inputs, const SizedBox(height: 20), results],
                      ),
              ),
            ),
          ),
        );

        if (isDesktop) return content;

        return Scaffold(
          appBar: const BrandingAppBar(title: 'Correia'),
          body: SingleChildScrollView(child: content),
        );
      },
    );
  }

  Widget _buildInputSection(MeasurementUnit unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Deixe em branco o campo que quer descobrir.',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 16),
        _sectionLabel('Diâmetros'),
        Row(
          children: [
            Expanded(child: CustomTextField(label: 'Polia maior', controller: _d1Controller, suffixText: unit.label, highlighted: _solved == 'd1')),
            const SizedBox(width: 12),
            Expanded(child: CustomTextField(label: 'Polia menor', controller: _d2Controller, suffixText: unit.label, highlighted: _solved == 'd2')),
          ],
        ),
        const SizedBox(height: 20),
        _sectionLabel('Geometria'),
        Row(
          children: [
            Expanded(child: CustomTextField(label: 'Entre centros', controller: _cController, suffixText: unit.label, highlighted: _solved == 'c')),
            const SizedBox(width: 12),
            Expanded(child: CustomTextField(label: 'Comprimento', controller: _lController, suffixText: unit.label, highlighted: _solved == 'l')),
          ],
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: _calculate, child: const Text('Calcular')),
        TextButton(
          onPressed: _reset,
          child: const Text('Limpar campos', style: TextStyle(color: AppTheme.textSecondary)),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
    );
  }

  Widget _buildResultSection(MeasurementUnit unit) {
    final info = _solvedInfo(unit);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ResultCard(label: info.label, value: info.value),
        const SizedBox(height: 16),
        Container(
          height: 180,
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.card,
          child: AnimatedPulleyDiagram(
            drivingDiameter: _result!.d1,
            drivenDiameter: _result!.d2,
            distance: _result!.c,
            animate: true,
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _isExporting ? null : _exportPdf,
          icon: _isExporting
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.picture_as_pdf_outlined),
          label: Text(_isExporting ? 'Gerando...' : 'Gerar relatório em PDF'),
        ),
        const SizedBox(height: 16),
        const DisclaimerWidget(),
      ],
    );
  }
}
