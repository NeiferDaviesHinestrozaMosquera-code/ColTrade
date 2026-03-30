part of 'subscription_bloc.dart';

abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final PlanTier activeTier;
  final bool isChanging;
  SubscriptionLoaded({required this.activeTier, this.isChanging = false});

  SubscriptionLoaded copyWith({PlanTier? activeTier, bool? isChanging}) {
    return SubscriptionLoaded(
      activeTier: activeTier ?? this.activeTier,
      isChanging: isChanging ?? this.isChanging,
    );
  }
}

class SubscriptionChangedSuccess extends SubscriptionState {
  final PlanTier newTier;
  SubscriptionChangedSuccess(this.newTier);
}

class SubscriptionError extends SubscriptionState {
  final String message;
  SubscriptionError(this.message);
}
