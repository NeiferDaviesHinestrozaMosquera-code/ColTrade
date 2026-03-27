part of 'logistics_bloc.dart';

enum LogisticsStatus { initial, loading, loaded, error }

class LogisticsState extends Equatable {
  final LogisticsStatus status;
  final List<Port> ports;
  final List<TradeRoute> routes;
  final List<LogisticsAlternative> alternatives;
  final Port? selectedPort;
  final TradeRoute? selectedRoute;
  final PortType? portTypeFilter;
  final int activeTab;
  final String? errorMessage;

  const LogisticsState({
    this.status = LogisticsStatus.initial,
    this.ports = const [],
    this.routes = const [],
    this.alternatives = const [],
    this.selectedPort,
    this.selectedRoute,
    this.portTypeFilter,
    this.activeTab = 0,
    this.errorMessage,
  });

  List<Port> get filteredPorts {
    if (portTypeFilter == null) return ports;
    return ports.where((p) => p.type == portTypeFilter).toList();
  }

  LogisticsState copyWith({
    LogisticsStatus? status,
    List<Port>? ports,
    List<TradeRoute>? routes,
    List<LogisticsAlternative>? alternatives,
    Port? selectedPort,
    TradeRoute? selectedRoute,
    PortType? portTypeFilter,
    int? activeTab,
    String? errorMessage,
    bool clearSelectedPort = false,
    bool clearSelectedRoute = false,
    bool clearFilter = false,
  }) {
    return LogisticsState(
      status: status ?? this.status,
      ports: ports ?? this.ports,
      routes: routes ?? this.routes,
      alternatives: alternatives ?? this.alternatives,
      selectedPort: clearSelectedPort ? null : (selectedPort ?? this.selectedPort),
      selectedRoute:
          clearSelectedRoute ? null : (selectedRoute ?? this.selectedRoute),
      portTypeFilter: clearFilter ? null : (portTypeFilter ?? this.portTypeFilter),
      activeTab: activeTab ?? this.activeTab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        ports,
        routes,
        alternatives,
        selectedPort,
        selectedRoute,
        portTypeFilter,
        activeTab,
        errorMessage,
      ];
}
