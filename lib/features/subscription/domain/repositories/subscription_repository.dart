import '../entities/subscription_plan.dart';

abstract class SubscriptionRepository {
  /// Returns the user's currently active plan tier.
  Future<PlanTier> getActivePlan();

  /// Requests a plan change. Returns true on success.
  Future<bool> changePlan(PlanTier newTier);
}
