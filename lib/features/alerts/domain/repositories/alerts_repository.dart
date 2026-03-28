import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/alert_entity.dart';

abstract class AlertsRepository {
  Future<Either<Failure, List<AlertEntity>>> getAlerts();
}
