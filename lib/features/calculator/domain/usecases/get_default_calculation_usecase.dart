import '../../../../core/usecases/usecase.dart';
import '../entities/cost_calculation_entity.dart';
import '../repositories/calculator_repository.dart';

class GetDefaultCalculationUseCase
    implements UseCase<CostCalculationEntity, NoParams> {
  final CalculatorRepository repository;

  GetDefaultCalculationUseCase(this.repository);

  @override
  Future<CostCalculationEntity> call(NoParams params) =>
      repository.getDefaultCalculation();
}
