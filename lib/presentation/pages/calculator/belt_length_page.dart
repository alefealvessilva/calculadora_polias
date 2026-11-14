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
        title: context.l10n.historyBeltTitle,
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
          content: Text(context.l10n.calcError(e)),
          backgroundColor: Colors.redAccent,
        ),
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
        title: l10n.pdfTitleBelt,
        inputs: {
          l10n.pdfLargePulley:
              '${UnitConverter.format(_result!.d1)} ${unit.label}',
          l10n.pdfSmallPulley:
              '${UnitConverter.format(_result!.d2)} ${unit.label}',
          l10n.pdfCenterDistance:
              '${UnitConverter.format(_result!.c)} ${unit.label}',
          l10n.pdfBeltLength:
              '${UnitConverter.format(_result!.l)} ${unit.label}',
        },
        results: {
          l10n.pdfResultDistance: '${UnitConverter.format(_result!.c)} ${unit.label}',
          l10n.pdfResultLength: '${UnitConverter.format(_result!.l)} ${unit.label}',
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
    final r = _result;

    return PageBody(
      children: [
        PageHeader(
          title: context.l10n.tabBelt,
          subtitle: context.l10n.hintLeaveBlank,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              FieldRow(
                left: CustomTextField(label: context.l10n.largePulley(unit.label), controller: _d1Controller, suffixText: unit.label),
                right: CustomTextField(label: context.l10n.smallPulley(unit.label), controller: _d2Controller, suffixText: unit.label),
              ),
              FieldRow(
                left: CustomTextField(label: context.l10n.centerDistance(unit.label), controller: _cController, suffixText: unit.label),
                right: CustomTextField(label: context.l10n.beltLength(unit.label), controller: _lController, suffixText: unit.label),
              ),
            ],
          ),
        ),
        ActionRow(onClear: _reset, onCalculate: _calculate),
        if (r != null) ...[
          const SizedBox(height: 20),
          ResultCard(
            label: context.l10n.beltResultLabel,
            value: '${UnitConverter.format(r.l)} ${unit.label}',
            exporting: _isExporting,
            onExport: _exportPdf,
            diagram: AnimatedPulleyDiagram(
              drivingDiameter: r.d1,
              drivenDiameter: r.d2,
              distance: r.c,
              animate: true,
            ),
          ),
        ],
        const DisclaimerText(),
      ],
    );
  }
}
