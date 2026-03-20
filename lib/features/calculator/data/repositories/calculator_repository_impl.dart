import '../../domain/entities/cost_calculation_entity.dart';
import '../../domain/repositories/calculator_repository.dart';

class CalculatorRepositoryImpl implements CalculatorRepository {
  @override
  Future<CostCalculationEntity> getDefaultCalculation() async {
    // Mock defaults – replace with local storage or API in production
    return const CostCalculationEntity(
      fob: 5000,
      insurance: 50,
      freightMode: 'sea',
      dutyPercent: 10,
      selectedPort: 'Buenaventura (SPRB/TCBUEN)',
    );
  }
}
