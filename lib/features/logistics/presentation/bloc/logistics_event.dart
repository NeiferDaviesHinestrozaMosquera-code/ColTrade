part of 'logistics_bloc.dart';

abstract class LogisticsEvent extends Equatable {
  const LogisticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadLogisticsData extends LogisticsEvent {
  const LoadLogisticsData();
}

class SelectPort extends LogisticsEvent {
  final Port port;
  const SelectPort(this.port);

  @override
  List<Object?> get props => [port];
}

class SelectRoute extends LogisticsEvent {
  final TradeRoute route;
  const SelectRoute(this.route);

  @override
  List<Object?> get props => [route];
}

class FilterByPortType extends LogisticsEvent {
  final PortType? portType;
  const FilterByPortType(this.portType);

  @override
  List<Object?> get props => [portType];
}

class SelectTab extends LogisticsEvent {
  final int tabIndex;
  const SelectTab(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class DismissSelection extends LogisticsEvent {
  const DismissSelection();
}
