import 'package:flutter/widgets.dart';
import 'package:calculadora_polias/core/utils/pdf_generator_service.dart';
import 'package:calculadora_polias/domain/usecases/calculations_usecases.dart';
import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension AppLocalizationsX on AppLocalizations {
  PdfLabels pdfLabels() => PdfLabels(
        appTitle: appTitle,
        params: pdfParams,
        results: pdfResults,
        diagram: pdfDiagram,
        formulas: pdfFormulas,
        warning: pdfWarning,
        warningText: pdfWarningText,
        informative: pdfInformative,
        locale: localeName,
      );

  String calcError(Object e) {
    if (e is CalcException) {
      switch (e.error) {
        case CalcError.zero:
          return errZero;
        case CalcError.oneBlank:
          return errOneBlank;
        case CalcError.geometry:
          return errGeometry;
        case CalcError.invalidResult:
          return errInvalidResult;
      }
    }
    return e.toString();
  }
}
