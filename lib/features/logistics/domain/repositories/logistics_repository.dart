import '../entities/port.dart';
import '../entities/trade_route.dart';
import '../entities/logistics_alternative.dart';

abstract class LogisticsRepository {
  Future<List<Port>> getPorts();
  Future<List<TradeRoute>> getRoutes();
  Future<List<LogisticsAlternative>> getAlternatives();
}
