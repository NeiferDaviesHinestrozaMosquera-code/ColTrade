import '../entities/subscription_plan.dart';
import '../repositories/subscription_repository.dart';

class ChangePlanUseCase {
  final SubscriptionRepository repository;
  const ChangePlanUseCase(this.repository);

  Future<bool> call(PlanTier newTier) => repository.changePlan(newTier);
}
