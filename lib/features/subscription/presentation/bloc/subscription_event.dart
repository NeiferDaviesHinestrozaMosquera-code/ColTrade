part of 'subscription_bloc.dart';

abstract class SubscriptionEvent {}

class SubscriptionLoadPlans extends SubscriptionEvent {}

class SubscriptionChangePlan extends SubscriptionEvent {
  final PlanTier newTier;
  SubscriptionChangePlan(this.newTier);
}
