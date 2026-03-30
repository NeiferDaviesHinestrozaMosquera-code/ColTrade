import '../../domain/entities/subscription_plan.dart';
import '../../domain/repositories/subscription_repository.dart';

/// Stub implementation – replace with real API/local persistence as needed.
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  /// Simulates the authenticated user's current plan (in-memory for now).
  PlanTier _activePlan = PlanTier.pro;

  @override
  Future<PlanTier> getActivePlan() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _activePlan;
  }

  @override
  Future<bool> changePlan(PlanTier newTier) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _activePlan = newTier;
    return true;
  }
}
