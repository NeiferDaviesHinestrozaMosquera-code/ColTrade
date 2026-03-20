import '../entities/cost_calculation_entity.dart';

abstract class CalculatorRepository {
  Future<CostCalculationEntity> getDefaultCalculation();
}
