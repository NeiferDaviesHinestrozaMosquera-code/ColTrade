import 'package:equatable/equatable.dart';

class CalculationParamsEntity extends Equatable {
  final double fob;
  final double insurance;
  final String freightMode; // 'air' | 'sea'
  final double dutyRatePercent;
  final String selectedPort;

  const CalculationParamsEntity({
    required this.fob,
    required this.insurance,
    required this.freightMode,
    required this.dutyRatePercent,
    required this.selectedPort,
  });

  // ── Computed values (pure business logic, no Flutter dependency) ──────────

  double get freight => freightMode == 'sea' ? 800 : 1400;
  double get cif => fob + freight + insurance;
  double get duty => cif * (dutyRatePercent / 100);
  double get iva => (cif + duty) * 0.19;
  double get agencyFee => 250;
  double get portFees => 180;
  double get totalLanded => cif + duty + iva + agencyFee + portFees;

  CalculationParamsEntity copyWith({
    double? fob,
    double? insurance,
    String? freightMode,
    double? dutyRatePercent,
    String? selectedPort,
  }) =>
      CalculationParamsEntity(
        fob: fob ?? this.fob,
        insurance: insurance ?? this.insurance,
        freightMode: freightMode ?? this.freightMode,
        dutyRatePercent: dutyRatePercent ?? this.dutyRatePercent,
        selectedPort: selectedPort ?? this.selectedPort,
      );

  @override
  List<Object?> get props =>
      [fob, insurance, freightMode, dutyRatePercent, selectedPort];
}
