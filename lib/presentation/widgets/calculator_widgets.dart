import 'package:flutter/material.dart';
import 'package:calculadora_polias/core/theme/app_theme.dart';
import 'package:calculadora_polias/l10n/l10n.dart';

/// Coluna central com largura máxima e rolagem. Usada por todas as telas.
class PageBody extends StatelessWidget {
  final List<Widget> children;
  const PageBody({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const PageHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Duas colunas de campos lado a lado.
class FieldRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  const FieldRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: 12),
          Expanded(child: right),
        ],
      ),
    );
  }
}

class ActionRow extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onCalculate;
  const ActionRow({super.key, required this.onClear, required this.onCalculate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(onPressed: onClear, child: Text(context.l10n.clear)),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: onCalculate,
            child: Text(context.l10n.calculate),
          ),
        ),
      ],
    );
  }
}

/// Resultado em destaque + diagrama + botão de PDF.
class ResultCard extends StatelessWidget {
  final String label;
  final String value;
  final Widget diagram;
  final bool exporting;
  final VoidCallback onExport;

  const ResultCard({
    super.key,
    required this.label,
    required this.value,
    required this.diagram,
    required this.exporting,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppTheme.accent,
              ),
            ),
            const SizedBox(height: 12),
            diagram,
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: exporting ? null : onExport,
              icon: exporting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.picture_as_pdf_outlined, size: 18),
              label: Text(exporting ? context.l10n.generating : context.l10n.exportPdf),
            ),
          ],
        ),
      ),
    );
  }
}

class DisclaimerText extends StatelessWidget {
  const DisclaimerText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        context.l10n.disclaimer,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, height: 1.4),
      ),
    );
  }
}
