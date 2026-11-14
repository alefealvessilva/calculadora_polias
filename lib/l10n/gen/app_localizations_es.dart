// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cálculo de RPM. Poleas y Correas';

  @override
  String get tabTransmission => 'Transmisión';

  @override
  String get tabBelt => 'Correa';

  @override
  String get tabHistory => 'Historial';

  @override
  String get hintLeaveBlank => 'Deja en blanco el campo que quieres descubrir.';

  @override
  String get motorRpm => 'RPM del motor';

  @override
  String get drivenRpm => 'RPM de la conducida';

  @override
  String motorDiameter(String unit) {
    return 'Diámetro motor ($unit)';
  }

  @override
  String drivenDiameter(String unit) {
    return 'Diámetro conducida ($unit)';
  }

  @override
  String largePulley(String unit) {
    return 'Polea mayor ($unit)';
  }

  @override
  String smallPulley(String unit) {
    return 'Polea menor ($unit)';
  }

  @override
  String centerDistance(String unit) {
    return 'Dist. entre centros ($unit)';
  }

  @override
  String beltLength(String unit) {
    return 'Longitud ($unit)';
  }

  @override
  String get clear => 'Limpiar';

  @override
  String get calculate => 'Calcular';

  @override
  String get ratioLabel => 'Relación de transmisión';

  @override
  String get beltResultLabel => 'Longitud de la correa';

  @override
  String get exportPdf => 'Exportar PDF';

  @override
  String get generating => 'Generando...';

  @override
  String get motor => 'Motor';

  @override
  String get driven => 'Conducida';

  @override
  String get disclaimer =>
      'Cálculos teóricos. Valídalos con un ingeniero responsable antes de aplicarlos en un proyecto.';

  @override
  String get required => 'Obligatorio';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get historyEmpty => 'Aún no hay cálculos guardados.';

  @override
  String get historyClear => 'Borrar historial';

  @override
  String get historyTransmissionTitle => 'Transmisión de poleas';

  @override
  String get historyBeltTitle => 'Longitud de correa';

  @override
  String get errZero => 'Ningún valor puede ser cero.';

  @override
  String get errOneBlank =>
      'Deja exactamente UN campo en blanco para calcularlo.';

  @override
  String get errGeometry => 'Geometría físicamente imposible para esta correa.';

  @override
  String get errInvalidResult =>
      'El resultado calculado no es válido. Revisa los valores.';

  @override
  String get rewardedTitle => 'Exportar informe en PDF';

  @override
  String get rewardedBody =>
      'Mira un anuncio corto para generar el PDF. Así la app sigue siendo gratuita.';

  @override
  String get rewardedWatch => 'Ver y exportar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get footerContact => 'Contacto';

  @override
  String get footerPrivacy => 'Privacidad';

  @override
  String get pdfTitleTransmission => 'Informe de Transmisión';

  @override
  String get pdfTitleBelt => 'Informe de Correa';

  @override
  String get pdfTitleHistoryTransmission => 'Historial: Transmisión';

  @override
  String get pdfTitleHistoryBelt => 'Historial: Correa';

  @override
  String get pdfParams => 'PARÁMETROS TÉCNICOS';

  @override
  String get pdfResults => 'RESULTADOS DE DIMENSIONAMIENTO';

  @override
  String get pdfDiagram => 'ESQUEMA TÉCNICO';

  @override
  String get pdfFormulas => 'MEMORIA DE CÁLCULO';

  @override
  String get pdfWarning => 'AVISO TÉCNICO';

  @override
  String get pdfWarningText =>
      'Cálculos teóricos basados en normas de ingeniería. La verificación por un ingeniero mecánico es obligatoria antes de la implementación física.';

  @override
  String get pdfInformative => 'Documento informativo';

  @override
  String get pdfMotorRpm => 'RPM Motor (N1)';

  @override
  String get pdfMotorPulley => 'Polea Motor (D1)';

  @override
  String get pdfDrivenRpm => 'RPM Conducida (N2)';

  @override
  String get pdfDrivenPulley => 'Polea Conducida (D2)';

  @override
  String get pdfRatio => 'Relación de Transmisión';

  @override
  String get pdfOutputRpm => 'RPM de Salida';

  @override
  String get pdfBaseFormula => 'Fórmula base: N1 * D1 = N2 * D2';

  @override
  String get pdfRatioFormula => 'Relación: i = D2 / D1';

  @override
  String get pdfLargePulley => 'Polea Mayor (D)';

  @override
  String get pdfSmallPulley => 'Polea Menor (d)';

  @override
  String get pdfCenterDistance => 'Distancia entre Centros (C)';

  @override
  String get pdfBeltLength => 'Longitud de la Correa (L)';

  @override
  String get pdfResultDistance => 'Distancia C';

  @override
  String get pdfResultLength => 'Longitud L';
}
