class UnitConverter {
  static const double inchToMmRatio = 25.4;

  // Converte polegada para mm
  static double inchToMm(double inches) {
    return inches * inchToMmRatio;
  }

  // Converte mm para polegada
  static double mmToInch(double mm) {
    return mm / inchToMmRatio;
  }

  /// Formata número para exibição limpa
  static String format(double value, {int fractionDigits = 2}) {
    String formatted = value.toStringAsFixed(fractionDigits);
    // Remove decimais desnecessários (ex: 2.00 -> 2)
    if (formatted.endsWith('.0') || formatted.endsWith('.00')) {
      return value.toInt().toString();
    }
    return formatted;
  }
}

enum MeasurementUnit { mm, inch }

extension MeasurementUnitExtension on MeasurementUnit {
  String get label {
    switch (this) {
      case MeasurementUnit.mm:
        return 'mm';
      case MeasurementUnit.inch:
        return 'pol';
    }
  }
}
