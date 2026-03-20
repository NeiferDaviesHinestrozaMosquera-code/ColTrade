part of 'calculator_bloc.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object> get props => [];
}

class UpdateFob extends CalculatorEvent {
  final double value;
  const UpdateFob(this.value);

  @override
  List<Object> get props => [value];
}

class UpdateInsurance extends CalculatorEvent {
  final double value;
  const UpdateInsurance(this.value);

  @override
  List<Object> get props => [value];
}

class UpdateFreightMode extends CalculatorEvent {
  final String mode; // 'sea' | 'air'
  const UpdateFreightMode(this.mode);

  @override
  List<Object> get props => [mode];
}

class UpdateDutyRate extends CalculatorEvent {
  final double percent; // e.g. 10 means 10%
  const UpdateDutyRate(this.percent);

  @override
  List<Object> get props => [percent];
}

class UpdatePort extends CalculatorEvent {
  final String port;
  const UpdatePort(this.port);

  @override
  List<Object> get props => [port];
}
