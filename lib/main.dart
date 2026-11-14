import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'l10n/gen/app_localizations.dart';
import 'presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env só guarda os IDs de anúncio; sem ele o app roda sem anúncios.
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    debugPrint('Sem .env: anúncios desativados.');
  }
  await initializeDateFormatting();

  runApp(const ProviderScope(child: CalculadoraApp()));
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Idioma segue o aparelho/navegador: pt, es ou en (fallback pt).
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supported) {
        for (final s in supported) {
          if (s.languageCode == locale?.languageCode) return s;
        }
        return const Locale('pt');
      },
      home: const HomePage(),
    );
  }
}
