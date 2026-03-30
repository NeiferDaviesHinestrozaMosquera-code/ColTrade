import '../entities/subscription_plan.dart';
import '../repositories/subscription_repository.dart';

class GetActivePlanUseCase {
  final SubscriptionRepository repository;
  const GetActivePlanUseCase(this.repository);

  Future<PlanTier> call() => repository.getActivePlan();
}
