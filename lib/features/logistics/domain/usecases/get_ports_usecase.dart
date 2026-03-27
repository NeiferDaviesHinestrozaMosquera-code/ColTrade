import '../entities/port.dart';
import '../repositories/logistics_repository.dart';

class GetPortsUseCase {
  final LogisticsRepository repository;
  const GetPortsUseCase(this.repository);

  Future<List<Port>> call() => repository.getPorts();
}
