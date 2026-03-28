import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/alert_entity.dart';
import '../repositories/alerts_repository.dart';

class GetAlertsUseCase implements UseCase<List<AlertEntity>, NoParams> {
  final AlertsRepository repository;

  GetAlertsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AlertEntity>>> call(NoParams params) => repository.getAlerts();
}
