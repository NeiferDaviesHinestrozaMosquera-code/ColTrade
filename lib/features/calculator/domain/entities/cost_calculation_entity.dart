import 'package:equatable/equatable.dart';

class CostCalculationEntity extends Equatable {
  final double fob;
  final double insurance;
  final String freightMode;
  final double dutyPercent;
  final String selectedPort;

  const CostCalculationEntity({
    required this.fob,
    required this.insurance,
    required this.freightMode,
    required this.dutyPercent,
    required this.selectedPort,
  });

  double get freight => freightMode == 'sea' ? 800 : 1400;
  double get cif => fob + freight + insurance;
  double get duty => cif * (dutyPercent / 100);
  double get iva => (cif + duty) * 0.19;
  double get agencyFee => 250;
  double get portFees => 180;
  double get totalLanded => cif + duty + iva + agencyFee + portFees;

  @override
  List<Object> get props => [fob, insurance, freightMode, dutyPercent, selectedPort];
}
