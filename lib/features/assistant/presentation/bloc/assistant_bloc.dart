import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/contact_agent_usecase.dart';
import '../../domain/usecases/classify_nandina_usecase.dart';
import 'assistant_event.dart';
import 'assistant_state.dart';

class AssistantBloc extends Bloc<AssistantEvent, AssistantState> {
  final ContactAgentUseCase contactAgent;
  final ClassifyNandinaUseCase classifyNandina;

  AssistantBloc({
    required this.contactAgent,
    required this.classifyNandina,
  }) : super(AssistantInitial()) {
    on<LoadAssistantDataEvent>((event, emit) async {
      emit(AssistantLoading());
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(const AssistantLoaded());
      } catch (e) {
        emit(AssistantError(message: e.toString()));
      }
    });

    on<ContactAgentEvent>((event, emit) async {
      emit(AssistantContactSending());
      try {
        await contactAgent(
          agentId: event.agentId,
          type: event.type,
          message: event.message,
        );
        emit(AssistantContactSuccess());
      } catch (e) {
        emit(AssistantError(message: e.toString()));
      }
    });

    on<ClassifyNandinaEvent>((event, emit) async {
      emit(AssistantNandinaClassifying());
      try {
        final result = await classifyNandina(event.query);
        emit(AssistantNandinaResult(result: result));
      } catch (e) {
        emit(AssistantError(message: e.toString()));
      }
    });
  }
}
