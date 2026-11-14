import 'dart:math';

/// Erros de cálculo independentes de idioma; a UI traduz cada código.
enum CalcError { zero, oneBlank, geometry, invalidResult }

class CalcException implements Exception {
  final CalcError error;
  const CalcException(this.error);
}

enum CalculationType {
  transmission,
  beltLength,
  pulleySizing
}

class HistoryItem {
  final String id;
  final CalculationType type;
  final String title;
  final String result;
  final DateTime date;
  final Map<String, dynamic>? calculationData;
  final String? unitLabel;

  HistoryItem({
    required this.id,
    required this.type,
    required this.title,
    required this.result,
    required this.date,
    this.calculationData,
    this.unitLabel,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'title': title,
      'result': result,
      'date': date.toIso8601String(),
      'calculationData': calculationData,
      'unitLabel': unitLabel,
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      type: CalculationType.values[json['type'] as int],
      title: json['title'],
      result: json['result'],
      date: DateTime.parse(json['date']),
      calculationData: json['calculationData'] != null 
          ? Map<String, dynamic>.from(json['calculationData']) 
          : null,
      unitLabel: json['unitLabel'],
    );
  }
}

class CalculationsUsecases {

  /// Cálculo de Transmissão
  /// Input: RPM Motor, Diâmetro Polia Motora, Diâmetro Polia Movida
  /// Retorna a RPM de Saída e a relação de transmissão
  static TransmissionResult calculateTransmission({
    required double motorRpm,
    required double drivingPulleyDiam,
    required double drivenPulleyDiam,
  }) {
    if (drivingPulleyDiam == 0 || drivenPulleyDiam == 0) {
      throw CalcException(CalcError.zero);
    }
    
    // N1 * D1 = N2 * D2  => N2 = (N1 * D1) / D2
    double outputRpm = (motorRpm * drivingPulleyDiam) / drivenPulleyDiam;
    
    // Relação = D2 / D1 (ex: se movida é duas vezes maior, relação é 1:2)
    double ratio = drivenPulleyDiam / drivingPulleyDiam;

    return TransmissionResult(
      outputRpm: outputRpm,
      ratio: ratio,
    );
  }

  /// Cálculo do Comprimento da Correia
  /// D = Diâmetro Maior
  /// d = Diâmetro Menor
  /// C = Distância entre centros
  /// L = 2C + 1.57(D+d) + (D-d)^2 / 4C
  static double calculateBeltLength({
    required double largerDiameter,
    required double smallerDiameter,
    required double centerDistance,
  }) {
    if (centerDistance == 0) {
      throw CalcException(CalcError.zero);
    }

    double D = largerDiameter;
    double d = smallerDiameter;
    double c = centerDistance;

    double part1 = 2 * c;
    double part2 = 1.57 * (D + d);
    double part3 = pow((D - d), 2) / (4 * c);

    return part1 + part2 + part3;
  }

  /// Dimensionamento de Polia
  /// Sabe o motor (RPM + Diâmetro) e quer a RPM de saída, descobre o diâmetro da polia movida
  /// D2 = (N1 * D1) / N2
  static double calculateDrivenPulleySize({
    required double motorRpm,
    required double drivingDiameter,
    required double targetOutputRpm,
  }) {
    if (targetOutputRpm == 0) {
      throw CalcException(CalcError.zero);
    }
    return (motorRpm * drivingDiameter) / targetOutputRpm;
  }

  /// Cálculo Dinâmico de Transmissão (Deixe um em branco)
  /// N1 * D1 = N2 * D2
  static DynamicTransmissionResult calculateDynamicTransmission({
    double? n1,
    double? d1,
    double? n2,
    double? d2,
  }) {
    int nullCount = [n1, d1, n2, d2].where((e) => e == null).length;
    if (nullCount != 1) {
      throw CalcException(CalcError.oneBlank);
    }

    if (n1 == null) {
      if (d1 == 0) throw CalcException(CalcError.zero);
      n1 = (n2! * d2!) / d1!;
    } else if (d1 == null) {
      if (n1 == 0) throw CalcException(CalcError.zero);
      d1 = (n2! * d2!) / n1;
    } else if (n2 == null) {
      if (d2 == 0) throw CalcException(CalcError.zero);
      n2 = (n1 * d1) / d2!;
    } else if (d2 == null) {
      if (n2 == 0) throw CalcException(CalcError.zero);
      d2 = (n1 * d1) / n2;
    }

    return DynamicTransmissionResult(
      n1: n1,
      d1: d1,
      n2: n2,
      d2: d2,
    );
  }

  /// Cálculo Dinâmico do Comprimento da Correia (Deixe um em branco)
  static BeltDynamicResult calculateDynamicBeltLength({
    double? d1,
    double? d2,
    double? c,
    double? l,
  }) {
    int nullCount = [d1, d2, c, l].where((e) => e == null).length;
    if (nullCount != 1) {
      throw CalcException(CalcError.oneBlank);
    }

    if (l == null) {
      if (c == 0) throw CalcException(CalcError.zero);
      l = 2 * c! + 1.57 * (d1! + d2!) + pow(d1 - d2, 2) / (4 * c);
    } else if (c == null) {
      double A = 8.0;
      double B = 6.28 * (d1! + d2!) - 4 * l;
      double co = pow(d1 - d2, 2).toDouble();
      double delta = B * B - 4 * A * co;
      if (delta < 0) throw CalcException(CalcError.geometry);
      double c1 = (-B + sqrt(delta)) / (2 * A);
      double c2 = (-B - sqrt(delta)) / (2 * A);
      c = max(c1, c2);
      if (c <= 0) throw CalcException(CalcError.zero);
    } else if (d1 == null) {
      double A = 1.0;
      double B = 6.28 * c - 2 * d2!;
      double co = 8 * c * c + 6.28 * c * d2 + d2 * d2 - 4 * c * l;
      double delta = B * B - 4 * A * co;
      if (delta < 0) throw CalcException(CalcError.geometry);
      double res1 = (-B + sqrt(delta)) / 2;
      double res2 = (-B - sqrt(delta)) / 2;
      d1 = max(res1, res2);
      if (d1 <= 0) throw CalcException(CalcError.invalidResult);
    } else if (d2 == null) {
      double A = 1.0;
      double B = 6.28 * c - 2 * d1;
      double co = 8 * c * c + 6.28 * c * d1 + d1 * d1 - 4 * c * l;
      double delta = B * B - 4 * A * co;
      if (delta < 0) throw CalcException(CalcError.geometry);
      double res1 = (-B + sqrt(delta)) / 2;
      double res2 = (-B - sqrt(delta)) / 2;
      d2 = max(res1, res2);
      if (d2 <= 0) throw CalcException(CalcError.invalidResult);
    }

    return BeltDynamicResult(
      d1: d1,
      d2: d2,
      c: c,
      l: l,
    );
  }
}

class TransmissionResult {
  final double outputRpm;
  final double ratio;

  TransmissionResult({required this.outputRpm, required this.ratio});
}

class DynamicTransmissionResult {
  final double n1;
  final double d1;
  final double n2;
  final double d2;

  DynamicTransmissionResult({
    required this.n1,
    required this.d1,
    required this.n2,
    required this.d2,
  });
  
  double get ratio => d2 / d1;
}

class BeltDynamicResult {
  final double d1;
  final double d2;
  final double c;
  final double l;

  BeltDynamicResult({
    required this.d1,
    required this.d2,
    required this.c,
    required this.l,
  });
}
