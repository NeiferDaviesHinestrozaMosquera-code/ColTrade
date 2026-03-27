import '../entities/trade_route.dart';
import '../entities/logistics_alternative.dart';
import '../repositories/logistics_repository.dart';

class GetRoutesUseCase {
  final LogisticsRepository repository;
  const GetRoutesUseCase(this.repository);

  Future<List<TradeRoute>> call() => repository.getRoutes();
}

class GetAlternativesUseCase {
  final LogisticsRepository repository;
  const GetAlternativesUseCase(this.repository);

  Future<List<LogisticsAlternative>> call() => repository.getAlternatives();
}
