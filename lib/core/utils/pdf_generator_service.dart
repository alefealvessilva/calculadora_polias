import 'dart:math' as math;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'web_utils.dart';

class PdfGeneratorService {
  static Future<void> exportCalculation({
    required String title,
    required Map<String, String> inputs,
    required Map<String, String> results,
    required List<String> formulas,
    required Map<String, double> diagramData,
  }) async {
    // 1. Mostrar Loader Nativo (Web)
    WebUtils.showNativeLoader();
    
    try {
      final date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

      // Pequeno delay para garantir que o loader JS seja visível
      await Future.delayed(const Duration(milliseconds: 100));

      // 2. Carregar Assets na Main Thread (Isolates não acessam rootBundle)
      final appLogoData = (await rootBundle.load('assets/images/app_logo.png')).buffer.asUint8List();
      final asclabsData = (await rootBundle.load('assets/images/logo_asclabs.png')).buffer.asUint8List();      // 3. Processar (Síncrono na thread principal para evitar erros de Binding e manter User Gesture)
      final pdfBytes = await _generatePdfBytes({
        'title': title,
        'inputs': inputs,
        'results': results,
        'formulas': formulas,
        'diagramData': diagramData,
        'date': date,
        'appLogoData': appLogoData,
        'asclabsData': asclabsData,
      });

      // 4. Exibir PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: 'Relatorio_${title.replaceAll(' ', '_')}.pdf',
      );
    } catch (e) {
      debugPrint('Erro ao exportar PDF: $e');
      rethrow;
    } finally {
      // 5. Remover Loader Nativo
      WebUtils.hideNativeLoader();
    }
  }

  static Future<Uint8List> _generatePdfBytes(Map<String, dynamic> params) async {
    final pdf = pw.Document();

    final String title = params['title'];
    final Map<String, String> inputs = params['inputs'];
    final Map<String, String> results = params['results'];
    final List<String> formulas = params['formulas'];
    final Map<String, double> diagramData = params['diagramData'];
    final String date = params['date'];

    final appLogo = pw.MemoryImage(params['appLogoData']);
    final asclabsLogo = pw.MemoryImage(params['asclabsData']);
    
    // Carregar Fontes dentro da Isolate/Worker (Acesso direto e seguro)
    final fontRegular = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();
    final fontItalic = await PdfGoogleFonts.interItalic();

    final cosmicTeal = PdfColor.fromHex('#00E5FF');
    final deepDark = PdfColor.fromHex('#050509');
    final surfaceDark = PdfColor.fromHex('#0C0C14');
    final stellarWhite = PdfColor.fromHex('#F8F9FA');
    final greyText = PdfColor.fromHex('#94A3B8');

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
          italic: fontItalic,
        ),
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(color: deepDark),
            padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // --- HEADER ---
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                      children: [
                        pw.Container(width: 35, height: 35, child: pw.Image(appLogo)),
                        pw.SizedBox(width: 12),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'CÁLCULO DE RPM. POLIAS E CORREIAS',
                              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: stellarWhite),
                            ),
                            pw.Row(children: [
                              pw.Text('by ', style: pw.TextStyle(fontSize: 7, color: greyText)),
                              pw.Container(height: 8, child: pw.Image(asclabsLogo)),
                            ]),
                          ],
                        ),
                      ],
                    ),
                    pw.Text(date, style: pw.TextStyle(fontSize: 9, color: greyText)),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Divider(thickness: 1, color: cosmicTeal.withAlpha(0.2)),
                pw.SizedBox(height: 10),

                pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: stellarWhite)),
                pw.SizedBox(height: 10),

                pw.Text('PARÂMETROS TÉCNICOS', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: cosmicTeal, letterSpacing: 1)),
                pw.SizedBox(height: 4),
                pw.Table(
                  children: inputs.entries.map((e) => pw.TableRow(
                    decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: stellarWhite.withAlpha(0.05), width: 0.5))),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 2), child: pw.Text(e.key, style: pw.TextStyle(fontSize: 9, color: greyText))),
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 2), child: pw.Text(e.value, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: stellarWhite))),
                    ],
                  )).toList(),
                ),
                pw.SizedBox(height: 15),

                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: surfaceDark,
                    border: pw.Border.all(color: cosmicTeal.withAlpha(0.4), width: 1),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('RESULTADOS DE DIMENSIONAMENTO', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: cosmicTeal)),
                      pw.SizedBox(height: 8),
                      pw.Table(
                        children: results.entries.map((e) => pw.TableRow(
                          children: [
                            pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 2), child: pw.Text(e.key, style: pw.TextStyle(fontSize: 10, color: greyText))),
                            pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 2), child: pw.Text(e.value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: stellarWhite))),
                          ],
                        )).toList(),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // SEÇÃO EXPANSÍVEL: DIAGRAMA E MEMÓRIA
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('ESQUEMA TÉCNICO', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: cosmicTeal)),
                      pw.SizedBox(height: 8),
                      pw.Expanded(
                        child: _buildNewDiagram(diagramData, cosmicTeal, stellarWhite),
                      ),
                      pw.SizedBox(height: 15),
                      pw.Text('MEMÓRIA DE CÁLCULO', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: greyText)),
                      pw.SizedBox(height: 4),
                      ...formulas.map((f) => pw.Text(f, style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic, color: greyText.withAlpha(0.6)))),
                    ],
                  ),
                ),

                pw.SizedBox(height: 20),
                pw.SizedBox(height: 20),

                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: stellarWhite.withAlpha(0.05),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                    border: pw.Border.all(color: stellarWhite.withAlpha(0.1)),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Container(
                            width: 12, height: 12,
                            decoration: const pw.BoxDecoration(color: PdfColors.cyan, shape: pw.BoxShape.circle),
                            child: pw.Center(child: pw.Text('!', style: pw.TextStyle(color: deepDark, fontSize: 8, fontWeight: pw.FontWeight.bold))),
                          ),
                          pw.SizedBox(width: 8),
                          pw.Text('AVISO TÉCNICO', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: greyText)),
                        ],
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Cálculos teóricos fundamentados em normas de engenharia. A verificação por um engenheiro mecânico é mandatória para a implementação física.',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(color: greyText, fontSize: 8, lineSpacing: 1.5),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Divider(thickness: 0.5, color: stellarWhite.withAlpha(0.1)),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('© 2026 ASCLABS', style: pw.TextStyle(fontSize: 7, color: greyText)),
                    pw.Text('Documento informativo', style: pw.TextStyle(fontSize: 7, color: greyText.withAlpha(0.6))),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return await pdf.save();
  }

  static pw.Widget _buildNewDiagram(Map<String, double> data, PdfColor accentColor, PdfColor textColor) {
    if (data.isEmpty) return pw.Container();

      final d1 = data['d1'] ?? 60.0;
      final d2 = data['d2'] ?? 120.0;
      final dist = data['distance'] ?? 150.0;

      // Garantir distância visual mínima (esquema técnico não-sobreposto)
      final double minVisualDist = (d1 / 2) + (d2 / 2) + (math.max(d1, d2) * 0.15);
      final double visualDist = math.max(dist, minVisualDist);

      return pw.LayoutBuilder(builder: (context, constraints) {
        final double containerWidth = constraints!.maxWidth - 2;
        final double containerHeight = constraints.maxHeight;

        const double limitFactor = 0.5;
        final double safeWidth = containerWidth * limitFactor;
        final double safeHeight = containerHeight * limitFactor;

        double totalLength = (d1 / 2) + visualDist + (d2 / 2);
        double scale = safeWidth / totalLength;
        
        double maxDiameter = math.max(d1, d2);
        if (maxDiameter * scale > safeHeight) {
          scale = safeHeight / maxDiameter;
        }

        final r1 = (d1 / 2) * scale;
        final r2 = (d2 / 2) * scale;
        final d = visualDist * scale;

        final double totalVisualWidth = r1 + d + r2;
        final double startX = (containerWidth - totalVisualWidth) / 2;
        final double centerX1 = startX + r1;
        final double centerX2 = startX + r1 + d;
        final double centerY = containerHeight / 2;

      return pw.Container(
        height: containerHeight,
        width: double.infinity,
        decoration: pw.BoxDecoration(
          color: PdfColor.fromHex('#0C0C14'),
          border: pw.Border.all(color: PdfColors.white.withAlpha(0.1)),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        ),
        child: pw.Stack(
          children: [
            pw.Positioned.fill(
              child: pw.CustomPaint(
                painter: (canvas, size) {
                  final double ratio = (r2 - r1) / d;
                  if (ratio.abs() <= 1.0) {
                    final double alpha = math.asin(ratio);
                    final double cosAlpha = math.cos(alpha);
                    final double sinAlpha = math.sin(alpha);

                    final double tx1Top = centerX1 - r1 * sinAlpha;
                    final double ty1Top = centerY + r1 * cosAlpha;
                    final double tx1Bot = centerX1 + r1 * sinAlpha;
                    final double ty1Bot = centerY - r1 * cosAlpha;

                    final double tx2Top = centerX2 - r2 * sinAlpha;
                    final double ty2Top = centerY + r2 * cosAlpha;
                    final double tx2Bot = centerX2 + r2 * sinAlpha;
                    final double ty2Bot = centerY - r2 * cosAlpha;

                    canvas.setLineWidth(1.0);
                    canvas.setStrokeColor(accentColor.withAlpha(0.4));
                    canvas.drawLine(tx1Top, ty1Top, tx2Top, ty2Top);
                    canvas.drawLine(tx1Bot, ty1Bot, tx2Bot, ty2Bot);
                    canvas.strokePath();
                  }

                  canvas.setStrokeColor(textColor.withAlpha(0.2));
                  canvas.drawLine(centerX1 - 4, centerY, centerX1 + 4, centerY);
                  canvas.drawLine(centerX1, centerY - 4, centerX1, centerY + 4);
                  canvas.drawLine(centerX2 - 4, centerY, centerX2 + 4, centerY);
                  canvas.drawLine(centerX2, centerY - 4, centerX2, centerY + 4);
                  canvas.strokePath();
                },
              ),
            ),
            pw.Positioned(
              left: centerX1 - r1,
              top: centerY - r1,
              child: pw.Container(
                width: r1 * 2,
                height: r1 * 2,
                decoration: pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  border: pw.Border.all(color: accentColor, width: 1.5),
                ),
              ),
            ),
            pw.Positioned(
              left: centerX2 - r2,
              top: centerY - r2,
              child: pw.Container(
                width: r2 * 2,
                height: r2 * 2,
                decoration: pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  border: pw.Border.all(color: accentColor, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
