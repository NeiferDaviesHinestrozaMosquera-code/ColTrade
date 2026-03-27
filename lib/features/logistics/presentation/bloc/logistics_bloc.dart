import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/port.dart';
import '../../domain/entities/trade_route.dart';
import '../../domain/entities/logistics_alternative.dart';
import '../../domain/usecases/get_ports_usecase.dart';
import '../../domain/usecases/get_routes_usecase.dart';

part 'logistics_event.dart';
part 'logistics_state.dart';

class LogisticsBloc extends Bloc<LogisticsEvent, LogisticsState> {
  final GetPortsUseCase _getPorts;
  final GetRoutesUseCase _getRoutes;
  final GetAlternativesUseCase _getAlternatives;

  LogisticsBloc({
    required GetPortsUseCase getPorts,
    required GetRoutesUseCase getRoutes,
    required GetAlternativesUseCase getAlternatives,
  })  : _getPorts = getPorts,
        _getRoutes = getRoutes,
        _getAlternatives = getAlternatives,
        super(const LogisticsState()) {
    on<LoadLogisticsData>(_onLoadData);
    on<SelectPort>(_onSelectPort);
    on<SelectRoute>(_onSelectRoute);
    on<FilterByPortType>(_onFilterByPortType);
    on<SelectTab>(_onSelectTab);
    on<DismissSelection>(_onDismissSelection);
  }

  Future<void> _onLoadData(
      LoadLogisticsData event, Emitter<LogisticsState> emit) async {
    emit(state.copyWith(status: LogisticsStatus.loading));
    try {
      final ports = await _getPorts();
      final routes = await _getRoutes();
      final alternatives = await _getAlternatives();
      emit(state.copyWith(
        status: LogisticsStatus.loaded,
        ports: ports,
        routes: routes,
        alternatives: alternatives,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LogisticsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSelectPort(SelectPort event, Emitter<LogisticsState> emit) {
    emit(state.copyWith(selectedPort: event.port, clearSelectedRoute: true));
  }

  void _onSelectRoute(SelectRoute event, Emitter<LogisticsState> emit) {
    emit(state.copyWith(selectedRoute: event.route, clearSelectedPort: true));
  }

  void _onFilterByPortType(
      FilterByPortType event, Emitter<LogisticsState> emit) {
    emit(state.copyWith(portTypeFilter: event.portType));
  }

  void _onSelectTab(SelectTab event, Emitter<LogisticsState> emit) {
    emit(state.copyWith(activeTab: event.tabIndex));
  }

  void _onDismissSelection(
      DismissSelection event, Emitter<LogisticsState> emit) {
    emit(state.copyWith(clearSelectedPort: true, clearSelectedRoute: true));
  }
}
