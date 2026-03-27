import '../../domain/entities/port.dart';
import '../../domain/entities/trade_route.dart';
import '../../domain/entities/logistics_alternative.dart';
import '../../domain/repositories/logistics_repository.dart';
import '../datasources/logistics_local_datasource.dart';

class LogisticsRepositoryImpl implements LogisticsRepository {
  final LogisticsLocalDatasource _datasource;

  const LogisticsRepositoryImpl(this._datasource);

  @override
  Future<List<Port>> getPorts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _datasource.getPorts();
  }

  @override
  Future<List<TradeRoute>> getRoutes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _datasource.getRoutes();
  }

  @override
  Future<List<LogisticsAlternative>> getAlternatives() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _datasource.getAlternatives();
  }
}
