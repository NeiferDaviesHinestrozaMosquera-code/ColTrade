import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'calculator_event.dart';
part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(const CalculatorState()) {
    on<UpdateFob>((e, emit) => emit(state.copyWith(fob: e.value)));
    on<UpdateInsurance>((e, emit) => emit(state.copyWith(insurance: e.value)));
    on<UpdateFreightMode>((e, emit) => emit(state.copyWith(freightMode: e.mode)));
    on<UpdateDutyRate>((e, emit) => emit(state.copyWith(dutyPercent: e.percent)));
    on<UpdatePort>((e, emit) => emit(state.copyWith(selectedPort: e.port)));
  }
}
