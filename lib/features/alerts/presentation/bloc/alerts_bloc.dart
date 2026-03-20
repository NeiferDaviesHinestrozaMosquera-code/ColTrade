import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_alerts_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import 'alerts_event.dart';
import 'alerts_state.dart';

class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  final GetAlertsUseCase getAlerts;

  AlertsBloc({required this.getAlerts}) : super(AlertsInitial()) {
    on<LoadAlerts>(_onLoad);
    on<FilterAlerts>(_onFilter);
  }

  Future<void> _onLoad(LoadAlerts event, Emitter<AlertsState> emit) async {
    emit(AlertsLoading());
    try {
      final alerts = await getAlerts(NoParams());
      emit(AlertsLoaded(
        allAlerts: alerts,
        filtered: alerts,
        activeFilter: 'Todas',
      ));
    } catch (e) {
      emit(AlertsError(e.toString()));
    }
  }

  void _onFilter(FilterAlerts event, Emitter<AlertsState> emit) {
    final current = state;
    if (current is! AlertsLoaded) return;

    final filtered = event.institution == 'Todas'
        ? current.allAlerts
        : current.allAlerts
            .where((a) => a.institution.contains(event.institution))
            .toList();

    emit(AlertsLoaded(
      allAlerts: current.allAlerts,
      filtered: filtered,
      activeFilter: event.institution,
    ));
  }
}
