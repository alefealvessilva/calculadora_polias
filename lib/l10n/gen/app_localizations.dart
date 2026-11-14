import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cálculo de RPM. Polias e Correias'**
  String get appTitle;

  /// No description provided for @tabTransmission.
  ///
  /// In pt, this message translates to:
  /// **'Transmissão'**
  String get tabTransmission;

  /// No description provided for @tabBelt.
  ///
  /// In pt, this message translates to:
  /// **'Correia'**
  String get tabBelt;

  /// No description provided for @tabHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico'**
  String get tabHistory;

  /// No description provided for @hintLeaveBlank.
  ///
  /// In pt, this message translates to:
  /// **'Deixe em branco o campo que deseja descobrir.'**
  String get hintLeaveBlank;

  /// No description provided for @motorRpm.
  ///
  /// In pt, this message translates to:
  /// **'RPM do motor'**
  String get motorRpm;

  /// No description provided for @drivenRpm.
  ///
  /// In pt, this message translates to:
  /// **'RPM da movida'**
  String get drivenRpm;

  /// No description provided for @motorDiameter.
  ///
  /// In pt, this message translates to:
  /// **'Diâmetro motor ({unit})'**
  String motorDiameter(String unit);

  /// No description provided for @drivenDiameter.
  ///
  /// In pt, this message translates to:
  /// **'Diâmetro movida ({unit})'**
  String drivenDiameter(String unit);

  /// No description provided for @largePulley.
  ///
  /// In pt, this message translates to:
  /// **'Polia maior ({unit})'**
  String largePulley(String unit);

  /// No description provided for @smallPulley.
  ///
  /// In pt, this message translates to:
  /// **'Polia menor ({unit})'**
  String smallPulley(String unit);

  /// No description provided for @centerDistance.
  ///
  /// In pt, this message translates to:
  /// **'Dist. centros ({unit})'**
  String centerDistance(String unit);

  /// No description provided for @beltLength.
  ///
  /// In pt, this message translates to:
  /// **'Comprimento ({unit})'**
  String beltLength(String unit);

  /// No description provided for @clear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get clear;

  /// No description provided for @calculate.
  ///
  /// In pt, this message translates to:
  /// **'Calcular'**
  String get calculate;

  /// No description provided for @ratioLabel.
  ///
  /// In pt, this message translates to:
  /// **'Relação de transmissão'**
  String get ratioLabel;

  /// No description provided for @beltResultLabel.
  ///
  /// In pt, this message translates to:
  /// **'Comprimento da correia'**
  String get beltResultLabel;

  /// No description provided for @exportPdf.
  ///
  /// In pt, this message translates to:
  /// **'Exportar PDF'**
  String get exportPdf;

  /// No description provided for @generating.
  ///
  /// In pt, this message translates to:
  /// **'Gerando...'**
  String get generating;

  /// No description provided for @motor.
  ///
  /// In pt, this message translates to:
  /// **'Motor'**
  String get motor;

  /// No description provided for @driven.
  ///
  /// In pt, this message translates to:
  /// **'Movida'**
  String get driven;

  /// No description provided for @disclaimer.
  ///
  /// In pt, this message translates to:
  /// **'Cálculos teóricos. Valide com um engenheiro responsável antes de aplicar em projeto.'**
  String get disclaimer;

  /// No description provided for @required.
  ///
  /// In pt, this message translates to:
  /// **'Obrigatório'**
  String get required;

  /// No description provided for @invalidNumber.
  ///
  /// In pt, this message translates to:
  /// **'Número inválido'**
  String get invalidNumber;

  /// No description provided for @historyEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum cálculo salvo ainda.'**
  String get historyEmpty;

  /// No description provided for @historyClear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar histórico'**
  String get historyClear;

  /// No description provided for @historyTransmissionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Transmissão de polias'**
  String get historyTransmissionTitle;

  /// No description provided for @historyBeltTitle.
  ///
  /// In pt, this message translates to:
  /// **'Comprimento de correia'**
  String get historyBeltTitle;

  /// No description provided for @errZero.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum valor pode ser zero.'**
  String get errZero;

  /// No description provided for @errOneBlank.
  ///
  /// In pt, this message translates to:
  /// **'Deixe exatamente UM campo em branco para ser calculado.'**
  String get errOneBlank;

  /// No description provided for @errGeometry.
  ///
  /// In pt, this message translates to:
  /// **'Geometria fisicamente impossível para essa correia.'**
  String get errGeometry;

  /// No description provided for @errInvalidResult.
  ///
  /// In pt, this message translates to:
  /// **'O resultado calculado é inválido. Revise os valores.'**
  String get errInvalidResult;

  /// No description provided for @rewardedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Exportar relatório em PDF'**
  String get rewardedTitle;

  /// No description provided for @rewardedBody.
  ///
  /// In pt, this message translates to:
  /// **'Assista a um anúncio curto para gerar o PDF. Isso mantém o app gratuito.'**
  String get rewardedBody;

  /// No description provided for @rewardedWatch.
  ///
  /// In pt, this message translates to:
  /// **'Assistir e exportar'**
  String get rewardedWatch;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @footerContact.
  ///
  /// In pt, this message translates to:
  /// **'Contato'**
  String get footerContact;

  /// No description provided for @footerPrivacy.
  ///
  /// In pt, this message translates to:
  /// **'Privacidade'**
  String get footerPrivacy;

  /// No description provided for @pdfTitleTransmission.
  ///
  /// In pt, this message translates to:
  /// **'Relatório de Transmissão'**
  String get pdfTitleTransmission;

  /// No description provided for @pdfTitleBelt.
  ///
  /// In pt, this message translates to:
  /// **'Relatório de Correia'**
  String get pdfTitleBelt;

  /// No description provided for @pdfTitleHistoryTransmission.
  ///
  /// In pt, this message translates to:
  /// **'Histórico: Transmissão'**
  String get pdfTitleHistoryTransmission;

  /// No description provided for @pdfTitleHistoryBelt.
  ///
  /// In pt, this message translates to:
  /// **'Histórico: Correia'**
  String get pdfTitleHistoryBelt;

  /// No description provided for @pdfParams.
  ///
  /// In pt, this message translates to:
  /// **'PARÂMETROS TÉCNICOS'**
  String get pdfParams;

  /// No description provided for @pdfResults.
  ///
  /// In pt, this message translates to:
  /// **'RESULTADOS DE DIMENSIONAMENTO'**
  String get pdfResults;

  /// No description provided for @pdfDiagram.
  ///
  /// In pt, this message translates to:
  /// **'ESQUEMA TÉCNICO'**
  String get pdfDiagram;

  /// No description provided for @pdfFormulas.
  ///
  /// In pt, this message translates to:
  /// **'MEMÓRIA DE CÁLCULO'**
  String get pdfFormulas;

  /// No description provided for @pdfWarning.
  ///
  /// In pt, this message translates to:
  /// **'AVISO TÉCNICO'**
  String get pdfWarning;

  /// No description provided for @pdfWarningText.
  ///
  /// In pt, this message translates to:
  /// **'Cálculos teóricos fundamentados em normas de engenharia. A verificação por um engenheiro mecânico é mandatória para a implementação física.'**
  String get pdfWarningText;

  /// No description provided for @pdfInformative.
  ///
  /// In pt, this message translates to:
  /// **'Documento informativo'**
  String get pdfInformative;

  /// No description provided for @pdfMotorRpm.
  ///
  /// In pt, this message translates to:
  /// **'RPM Motor (N1)'**
  String get pdfMotorRpm;

  /// No description provided for @pdfMotorPulley.
  ///
  /// In pt, this message translates to:
  /// **'Polia Motor (D1)'**
  String get pdfMotorPulley;

  /// No description provided for @pdfDrivenRpm.
  ///
  /// In pt, this message translates to:
  /// **'RPM Movida (N2)'**
  String get pdfDrivenRpm;

  /// No description provided for @pdfDrivenPulley.
  ///
  /// In pt, this message translates to:
  /// **'Polia Movida (D2)'**
  String get pdfDrivenPulley;

  /// No description provided for @pdfRatio.
  ///
  /// In pt, this message translates to:
  /// **'Relação de Transmissão'**
  String get pdfRatio;

  /// No description provided for @pdfOutputRpm.
  ///
  /// In pt, this message translates to:
  /// **'RPM de Saída'**
  String get pdfOutputRpm;

  /// No description provided for @pdfBaseFormula.
  ///
  /// In pt, this message translates to:
  /// **'Fórmula Base: N1 * D1 = N2 * D2'**
  String get pdfBaseFormula;

  /// No description provided for @pdfRatioFormula.
  ///
  /// In pt, this message translates to:
  /// **'Relação: i = D2 / D1'**
  String get pdfRatioFormula;

  /// No description provided for @pdfLargePulley.
  ///
  /// In pt, this message translates to:
  /// **'Polia Maior (D)'**
  String get pdfLargePulley;

  /// No description provided for @pdfSmallPulley.
  ///
  /// In pt, this message translates to:
  /// **'Polia Menor (d)'**
  String get pdfSmallPulley;

  /// No description provided for @pdfCenterDistance.
  ///
  /// In pt, this message translates to:
  /// **'Distância entre Centros (C)'**
  String get pdfCenterDistance;

  /// No description provided for @pdfBeltLength.
  ///
  /// In pt, this message translates to:
  /// **'Comprimento da Correia (L)'**
  String get pdfBeltLength;

  /// No description provided for @pdfResultDistance.
  ///
  /// In pt, this message translates to:
  /// **'Distância C'**
  String get pdfResultDistance;

  /// No description provided for @pdfResultLength.
  ///
  /// In pt, this message translates to:
  /// **'Comprimento L'**
  String get pdfResultLength;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
