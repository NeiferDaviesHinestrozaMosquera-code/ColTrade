import 'package:flutter_bloc/flutter_bloc.dart';
import 'assistant_event.dart';
import 'assistant_state.dart';

class AssistantBloc extends Bloc<AssistantEvent, AssistantState> {
  AssistantBloc() : super(AssistantInitial()) {
    on<LoadAssistantDataEvent>((event, emit) async {
      emit(AssistantLoading());
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(const AssistantLoaded());
      } catch (e) {
        emit(AssistantError(message: e.toString()));
      }
    });
  }
}
