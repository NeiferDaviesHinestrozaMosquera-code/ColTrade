import '../../../../core/usecases/usecase.dart';
import '../entities/alert_entity.dart';
import '../repositories/alerts_repository.dart';

class GetAlertsUseCase implements UseCase<List<AlertEntity>, NoParams> {
  final AlertsRepository repository;

  GetAlertsUseCase(this.repository);

  @override
  Future<List<AlertEntity>> call(NoParams params) => repository.getAlerts();
}
