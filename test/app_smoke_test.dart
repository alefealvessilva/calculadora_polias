import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora_polias/main.dart';

Future<void> _pump(WidgetTester tester, Locale locale) async {
  tester.platformDispatcher.localesTestValue = [locale];
  tester.view.physicalSize = const Size(900, 1600);
  tester.view.devicePixelRatio = 2;
  await tester.pumpWidget(const ProviderScope(child: CalculadoraApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('abre em portugues e calcula transmissao', (tester) async {
    await _pump(tester, const Locale('pt', 'BR'));
    expect(find.text('Calcular'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '1750'); // RPM motor
    await tester.enterText(fields.at(1), '100'); // D motor
    await tester.enterText(fields.at(3), '200'); // D movida (RPM movida em branco)
    await tester.tap(find.text('Calcular'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('1 : 2'), findsOneWidget);
    expect(find.text('Exportar PDF'), findsOneWidget);
  });

  testWidgets('segue o idioma do aparelho (es, en e fallback)', (tester) async {
    await _pump(tester, const Locale('es', 'MX'));
    expect(find.text('Calcular'), findsOneWidget);
    expect(find.text('Historial'), findsWidgets);

    await _pump(tester, const Locale('en', 'US'));
    expect(find.text('Calculate'), findsOneWidget);

    await _pump(tester, const Locale('hi', 'IN'));
    expect(find.text('Calcular'), findsOneWidget);
  });

  testWidgets('erro de campos vem traduzido', (tester) async {
    await _pump(tester, const Locale('en', 'US'));
    final fields = find.byType(TextFormField);
    for (var i = 0; i < 4; i++) {
      await tester.enterText(fields.at(i), '10');
    }
    await tester.tap(find.text('Calculate'));
    await tester.pump();
    expect(find.text('Leave exactly ONE field blank to be calculated.'), findsOneWidget);
  });
}
