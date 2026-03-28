import '../../../../core/usecases/usecase.dart';
import '../entities/cost_calculation_entity.dart';
import '../repositories/calculator_repository.dart';

class GetDefaultCalculationUseCase {
  final CalculatorRepository repository;

  GetDefaultCalculationUseCase(this.repository);

  Future<CostCalculationEntity> call(NoParams params) =>
      repository.getDefaultCalculation();
}
