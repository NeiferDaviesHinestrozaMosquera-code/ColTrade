import 'package:equatable/equatable.dart';
import '../../domain/entities/alert_entity.dart';

abstract class AlertsState extends Equatable {
  const AlertsState();
  @override
  List<Object?> get props => [];
}

class AlertsInitial extends AlertsState {}

class AlertsLoading extends AlertsState {}

class AlertsLoaded extends AlertsState {
  final List<AlertEntity> allAlerts;
  final List<AlertEntity> filtered;
  final String activeFilter;

  const AlertsLoaded({
    required this.allAlerts,
    required this.filtered,
    required this.activeFilter,
  });

  @override
  List<Object?> get props => [allAlerts, filtered, activeFilter];
}

class AlertsError extends AlertsState {
  final String message;
  const AlertsError(this.message);

  @override
  List<Object?> get props => [message];
}
