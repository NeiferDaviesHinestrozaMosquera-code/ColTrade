import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/subscription_plan.dart';
import '../../domain/usecases/get_active_plan_usecase.dart';
import '../../domain/usecases/change_plan_usecase.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final GetActivePlanUseCase getActivePlan;
  final ChangePlanUseCase changePlan;

  SubscriptionBloc({
    required this.getActivePlan,
    required this.changePlan,
  }) : super(SubscriptionInitial()) {
    on<SubscriptionLoadPlans>(_onLoadPlans);
    on<SubscriptionChangePlan>(_onChangePlan);
  }

  Future<void> _onLoadPlans(
    SubscriptionLoadPlans event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      final tier = await getActivePlan();
      emit(SubscriptionLoaded(activeTier: tier));
    } catch (e) {
      emit(SubscriptionError('No se pudo cargar el plan activo.'));
    }
  }

  Future<void> _onChangePlan(
    SubscriptionChangePlan event,
    Emitter<SubscriptionState> emit,
  ) async {
    final current = state;
    if (current is SubscriptionLoaded) {
      emit(current.copyWith(isChanging: true));
      try {
        final success = await changePlan(event.newTier);
        if (success) {
          emit(SubscriptionChangedSuccess(event.newTier));
          emit(SubscriptionLoaded(activeTier: event.newTier));
        } else {
          emit(SubscriptionError('No se pudo cambiar el plan.'));
          emit(SubscriptionLoaded(activeTier: current.activeTier));
        }
      } catch (e) {
        emit(SubscriptionError('Ocurrió un error al cambiar el plan.'));
        emit(SubscriptionLoaded(activeTier: current.activeTier));
      }
    }
  }
}
