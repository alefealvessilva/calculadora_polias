import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculadora_polias/core/ads/ad_helper.dart';
import 'package:calculadora_polias/core/utils/unit_converter.dart';
import 'package:calculadora_polias/domain/usecases/calculations_usecases.dart';
import 'package:calculadora_polias/presentation/providers/app_providers.dart';
import 'package:calculadora_polias/core/utils/pdf_generator_service.dart';
import 'package:calculadora_polias/presentation/widgets/custom_text_field.dart';
import 'package:calculadora_polias/presentation/widgets/pulley_diagram_painter.dart';
import 'package:calculadora_polias/presentation/widgets/calculator_widgets.dart';
import 'package:calculadora_polias/l10n/l10n.dart';
import 'package:calculadora_polias/core/ads/export_gate.dart';

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
        title: context.l10n.historyTransmissionTitle,
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
        SnackBar(content: Text(context.l10n.calcError(e)), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _exportPdf() async {
    if (_result == null || _isExporting) return;
    await runWithRewardedGate(context, _doExport);
  }

  Future<void> _doExport() async {
    if (_result == null || _isExporting || !mounted) return;
    final l10n = context.l10n;

    setState(() => _isExporting = true);
    
    try {
      final unit = ref.read(unitProvider);
      await PdfGeneratorService.exportCalculation(
        labels: l10n.pdfLabels(),
        title: l10n.pdfTitleTransmission,
        inputs: {
          l10n.pdfMotorRpm: '${UnitConverter.format(_result!.n1)} RPM',
          l10n.pdfMotorPulley: '${UnitConverter.format(_result!.d1)} ${unit.label}',
          l10n.pdfDrivenRpm: '${UnitConverter.format(_result!.n2)} RPM',
          l10n.pdfDrivenPulley: '${UnitConverter.format(_result!.d2)} ${unit.label}',
        },
        results: {
          l10n.pdfRatio: '1 : ${UnitConverter.format(_result!.ratio)}',
          l10n.pdfOutputRpm: '${UnitConverter.format(_result!.n2)} RPM',
        },
        formulas: [l10n.pdfBaseFormula, l10n.pdfRatioFormula],
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
    final r = _result;

    return PageBody(
      children: [
        PageHeader(
          title: context.l10n.tabTransmission,
          subtitle: context.l10n.hintLeaveBlank,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              FieldRow(
                left: CustomTextField(label: context.l10n.motorRpm, controller: _n1Controller, suffixText: 'RPM'),
                right: CustomTextField(label: context.l10n.motorDiameter(unit.label), controller: _d1Controller, suffixText: unit.label),
              ),
              FieldRow(
                left: CustomTextField(label: context.l10n.drivenRpm, controller: _n2Controller, suffixText: 'RPM'),
                right: CustomTextField(label: context.l10n.drivenDiameter(unit.label), controller: _d2Controller, suffixText: unit.label),
              ),
            ],
          ),
        ),
        ActionRow(onClear: _reset, onCalculate: _calculate),
        if (r != null) ...[
          const SizedBox(height: 20),
          ResultCard(
            label: context.l10n.ratioLabel,
            value: '1 : ${UnitConverter.format(r.ratio)}',
            exporting: _isExporting,
            onExport: _exportPdf,
            diagram: PulleySystemDiagram(
              n1: r.n1,
              d1: r.d1,
              n2: r.n2,
              d2: r.d2,
              animate: true,
            ),
          ),
        ],
        const DisclaimerText(),
      ],
    );
  }
}
