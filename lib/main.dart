import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/splash_page.dart';

void main() async {
  // Garantir inicialização básica dos bindings
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: CalculadoraPoliasCorreiasApp()));
}

class CalculadoraPoliasCorreiasApp extends StatefulWidget {
  const CalculadoraPoliasCorreiasApp({super.key});

  @override
  State<CalculadoraPoliasCorreiasApp> createState() =>
      _CalculadoraPoliasCorreiasAppState();
}

class _CalculadoraPoliasCorreiasAppState
    extends State<CalculadoraPoliasCorreiasApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // 1. Carregar variáveis de ambiente de forma segura
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint('Aviso: Arquivo .env não encontrado. Anúncios serão desativados.');
    }

    // 2. Configurações Globais
    await initializeDateFormatting('pt_BR', null);

    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cálculo de RPM. Polias e Correias',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _initialized ? const HomePage() : const SplashPage(),
    );
  }
}
