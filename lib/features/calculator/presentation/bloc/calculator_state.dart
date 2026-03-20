part of 'calculator_bloc.dart';

class CalculatorState extends Equatable {
  final double fob;
  final double insurance;
  final String freightMode;
  final double dutyPercent;
  final String selectedPort;

  const CalculatorState({
    this.fob = 5000,
    this.insurance = 50,
    this.freightMode = 'sea',
    this.dutyPercent = 10,
    this.selectedPort = 'Buenaventura (SPRB/TCBUEN)',
  });

  double get freight => freightMode == 'sea' ? 800 : 1400;
  double get cif => fob + freight + insurance;
  double get duty => cif * (dutyPercent / 100);
  double get iva => (cif + duty) * 0.19;
  double get agencyFee => 250;
  double get portFees => 180;
  double get totalLanded => cif + duty + iva + agencyFee + portFees;

  CalculatorState copyWith({
    double? fob,
    double? insurance,
    String? freightMode,
    double? dutyPercent,
    String? selectedPort,
  }) {
    return CalculatorState(
      fob: fob ?? this.fob,
      insurance: insurance ?? this.insurance,
      freightMode: freightMode ?? this.freightMode,
      dutyPercent: dutyPercent ?? this.dutyPercent,
      selectedPort: selectedPort ?? this.selectedPort,
    );
  }

  @override
  List<Object> get props => [fob, insurance, freightMode, dutyPercent, selectedPort];
}
