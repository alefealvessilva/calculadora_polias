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
import 'package:calculadora_polias/presentation/widgets/pulley_system_diagram.dart';
import 'package:calculadora_polias/presentation/widgets/result_card.dart';

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
  String? _solved; // campo que foi deixado em branco e calculado
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

    final solved = n1 == null ? 'n1' : d1 == null ? 'd1' : n2 == null ? 'n2' : 'd2';

    try {
      final result = CalculationsUsecases.calculateDynamicTransmission(
        n1: n1, d1: d1, n2: n2, d2: d2,
      );

      setState(() {
        _result = result;
        _solved = solved;
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
    setState(() { _result = null; _solved = null; });
  }

  ({String label, String value}) _solvedInfo(MeasurementUnit unit) {
    final r = _result!;
    switch (_solved) {
      case 'n1':
        return (label: 'RPM do motor', value: '${UnitConverter.format(r.n1)} RPM');
      case 'd1':
        return (label: 'Diâmetro da polia motora', value: '${UnitConverter.format(r.d1)} ${unit.label}');
      case 'd2':
        return (label: 'Diâmetro da polia movida', value: '${UnitConverter.format(r.d2)} ${unit.label}');
      default:
        return (label: 'RPM de saída', value: '${UnitConverter.format(r.n2)} RPM');
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
          appBar: const BrandingAppBar(title: 'Transmissão'),
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
        _sectionLabel('Polia motora'),
        Row(
          children: [
            Expanded(child: CustomTextField(label: 'RPM', controller: _n1Controller, suffixText: 'RPM', highlighted: _solved == 'n1')),
            const SizedBox(width: 12),
            Expanded(child: CustomTextField(label: 'Diâmetro', controller: _d1Controller, suffixText: unit.label, highlighted: _solved == 'd1')),
          ],
        ),
        const SizedBox(height: 20),
        _sectionLabel('Polia movida'),
        Row(
          children: [
            Expanded(child: CustomTextField(label: 'RPM', controller: _n2Controller, suffixText: 'RPM', highlighted: _solved == 'n2')),
            const SizedBox(width: 12),
            Expanded(child: CustomTextField(label: 'Diâmetro', controller: _d2Controller, suffixText: unit.label, highlighted: _solved == 'd2')),
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
        ResultCard(
          label: info.label,
          value: info.value,
          detail: 'Relação de transmissão  1 : ${UnitConverter.format(_result!.ratio)}',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.card,
          child: PulleySystemDiagram(
            n1: _result!.n1,
            d1: _result!.d1,
            n2: _result!.n2,
            d2: _result!.d2,
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
