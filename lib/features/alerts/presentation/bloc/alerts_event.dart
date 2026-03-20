import 'package:equatable/equatable.dart';

abstract class AlertsEvent extends Equatable {
  const AlertsEvent();
  @override
  List<Object?> get props => [];
}

class LoadAlerts extends AlertsEvent {
  const LoadAlerts();
}

class FilterAlerts extends AlertsEvent {
  final String institution;
  const FilterAlerts(this.institution);

  @override
  List<Object?> get props => [institution];
}
