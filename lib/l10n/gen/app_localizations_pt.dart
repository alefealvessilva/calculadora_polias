// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Cálculo de RPM. Polias e Correias';

  @override
  String get tabTransmission => 'Transmissão';

  @override
  String get tabBelt => 'Correia';

  @override
  String get tabHistory => 'Histórico';

  @override
  String get hintLeaveBlank => 'Deixe em branco o campo que deseja descobrir.';

  @override
  String get motorRpm => 'RPM do motor';

  @override
  String get drivenRpm => 'RPM da movida';

  @override
  String motorDiameter(String unit) {
    return 'Diâmetro motor ($unit)';
  }

  @override
  String drivenDiameter(String unit) {
    return 'Diâmetro movida ($unit)';
  }

  @override
  String largePulley(String unit) {
    return 'Polia maior ($unit)';
  }

  @override
  String smallPulley(String unit) {
    return 'Polia menor ($unit)';
  }

  @override
  String centerDistance(String unit) {
    return 'Dist. centros ($unit)';
  }

  @override
  String beltLength(String unit) {
    return 'Comprimento ($unit)';
  }

  @override
  String get clear => 'Limpar';

  @override
  String get calculate => 'Calcular';

  @override
  String get ratioLabel => 'Relação de transmissão';

  @override
  String get beltResultLabel => 'Comprimento da correia';

  @override
  String get exportPdf => 'Exportar PDF';

  @override
  String get generating => 'Gerando...';

  @override
  String get motor => 'Motor';

  @override
  String get driven => 'Movida';

  @override
  String get disclaimer =>
      'Cálculos teóricos. Valide com um engenheiro responsável antes de aplicar em projeto.';

  @override
  String get required => 'Obrigatório';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get historyEmpty => 'Nenhum cálculo salvo ainda.';

  @override
  String get historyClear => 'Limpar histórico';

  @override
  String get historyTransmissionTitle => 'Transmissão de polias';

  @override
  String get historyBeltTitle => 'Comprimento de correia';

  @override
  String get errZero => 'Nenhum valor pode ser zero.';

  @override
  String get errOneBlank =>
      'Deixe exatamente UM campo em branco para ser calculado.';

  @override
  String get errGeometry =>
      'Geometria fisicamente impossível para essa correia.';

  @override
  String get errInvalidResult =>
      'O resultado calculado é inválido. Revise os valores.';

  @override
  String get rewardedTitle => 'Exportar relatório em PDF';

  @override
  String get rewardedBody =>
      'Assista a um anúncio curto para gerar o PDF. Isso mantém o app gratuito.';

  @override
  String get rewardedWatch => 'Assistir e exportar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get footerContact => 'Contato';

  @override
  String get footerPrivacy => 'Privacidade';

  @override
  String get pdfTitleTransmission => 'Relatório de Transmissão';

  @override
  String get pdfTitleBelt => 'Relatório de Correia';

  @override
  String get pdfTitleHistoryTransmission => 'Histórico: Transmissão';

  @override
  String get pdfTitleHistoryBelt => 'Histórico: Correia';

  @override
  String get pdfParams => 'PARÂMETROS TÉCNICOS';

  @override
  String get pdfResults => 'RESULTADOS DE DIMENSIONAMENTO';

  @override
  String get pdfDiagram => 'ESQUEMA TÉCNICO';

  @override
  String get pdfFormulas => 'MEMÓRIA DE CÁLCULO';

  @override
  String get pdfWarning => 'AVISO TÉCNICO';

  @override
  String get pdfWarningText =>
      'Cálculos teóricos fundamentados em normas de engenharia. A verificação por um engenheiro mecânico é mandatória para a implementação física.';

  @override
  String get pdfInformative => 'Documento informativo';

  @override
  String get pdfMotorRpm => 'RPM Motor (N1)';

  @override
  String get pdfMotorPulley => 'Polia Motor (D1)';

  @override
  String get pdfDrivenRpm => 'RPM Movida (N2)';

  @override
  String get pdfDrivenPulley => 'Polia Movida (D2)';

  @override
  String get pdfRatio => 'Relação de Transmissão';

  @override
  String get pdfOutputRpm => 'RPM de Saída';

  @override
  String get pdfBaseFormula => 'Fórmula Base: N1 * D1 = N2 * D2';

  @override
  String get pdfRatioFormula => 'Relação: i = D2 / D1';

  @override
  String get pdfLargePulley => 'Polia Maior (D)';

  @override
  String get pdfSmallPulley => 'Polia Menor (d)';

  @override
  String get pdfCenterDistance => 'Distância entre Centros (C)';

  @override
  String get pdfBeltLength => 'Comprimento da Correia (L)';

  @override
  String get pdfResultDistance => 'Distância C';

  @override
  String get pdfResultLength => 'Comprimento L';
}
