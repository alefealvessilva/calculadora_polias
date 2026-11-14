// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RPM Calculator. Pulleys and Belts';

  @override
  String get tabTransmission => 'Drive';

  @override
  String get tabBelt => 'Belt';

  @override
  String get tabHistory => 'History';

  @override
  String get hintLeaveBlank => 'Leave blank the field you want to find.';

  @override
  String get motorRpm => 'Motor RPM';

  @override
  String get drivenRpm => 'Driven RPM';

  @override
  String motorDiameter(String unit) {
    return 'Motor diameter ($unit)';
  }

  @override
  String drivenDiameter(String unit) {
    return 'Driven diameter ($unit)';
  }

  @override
  String largePulley(String unit) {
    return 'Large pulley ($unit)';
  }

  @override
  String smallPulley(String unit) {
    return 'Small pulley ($unit)';
  }

  @override
  String centerDistance(String unit) {
    return 'Center distance ($unit)';
  }

  @override
  String beltLength(String unit) {
    return 'Length ($unit)';
  }

  @override
  String get clear => 'Clear';

  @override
  String get calculate => 'Calculate';

  @override
  String get ratioLabel => 'Drive ratio';

  @override
  String get beltResultLabel => 'Belt length';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get generating => 'Generating...';

  @override
  String get motor => 'Motor';

  @override
  String get driven => 'Driven';

  @override
  String get disclaimer =>
      'Theoretical calculations. Have a qualified engineer verify them before use in a project.';

  @override
  String get required => 'Required';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get historyEmpty => 'No saved calculations yet.';

  @override
  String get historyClear => 'Clear history';

  @override
  String get historyTransmissionTitle => 'Pulley drive';

  @override
  String get historyBeltTitle => 'Belt length';

  @override
  String get errZero => 'No value can be zero.';

  @override
  String get errOneBlank => 'Leave exactly ONE field blank to be calculated.';

  @override
  String get errGeometry => 'Physically impossible geometry for this belt.';

  @override
  String get errInvalidResult =>
      'The calculated result is invalid. Check your values.';

  @override
  String get rewardedTitle => 'Export PDF report';

  @override
  String get rewardedBody =>
      'Watch a short ad to generate the PDF. This keeps the app free.';

  @override
  String get rewardedWatch => 'Watch and export';

  @override
  String get cancel => 'Cancel';

  @override
  String get footerContact => 'Contact';

  @override
  String get footerPrivacy => 'Privacy';

  @override
  String get pdfTitleTransmission => 'Drive Report';

  @override
  String get pdfTitleBelt => 'Belt Report';

  @override
  String get pdfTitleHistoryTransmission => 'History: Drive';

  @override
  String get pdfTitleHistoryBelt => 'History: Belt';

  @override
  String get pdfParams => 'TECHNICAL PARAMETERS';

  @override
  String get pdfResults => 'SIZING RESULTS';

  @override
  String get pdfDiagram => 'TECHNICAL DIAGRAM';

  @override
  String get pdfFormulas => 'CALCULATION NOTES';

  @override
  String get pdfWarning => 'TECHNICAL NOTICE';

  @override
  String get pdfWarningText =>
      'Theoretical calculations based on engineering standards. Verification by a mechanical engineer is mandatory before physical implementation.';

  @override
  String get pdfInformative => 'Informational document';

  @override
  String get pdfMotorRpm => 'Motor RPM (N1)';

  @override
  String get pdfMotorPulley => 'Motor Pulley (D1)';

  @override
  String get pdfDrivenRpm => 'Driven RPM (N2)';

  @override
  String get pdfDrivenPulley => 'Driven Pulley (D2)';

  @override
  String get pdfRatio => 'Drive Ratio';

  @override
  String get pdfOutputRpm => 'Output RPM';

  @override
  String get pdfBaseFormula => 'Base formula: N1 * D1 = N2 * D2';

  @override
  String get pdfRatioFormula => 'Ratio: i = D2 / D1';

  @override
  String get pdfLargePulley => 'Large Pulley (D)';

  @override
  String get pdfSmallPulley => 'Small Pulley (d)';

  @override
  String get pdfCenterDistance => 'Center Distance (C)';

  @override
  String get pdfBeltLength => 'Belt Length (L)';

  @override
  String get pdfResultDistance => 'Distance C';

  @override
  String get pdfResultLength => 'Length L';
}
