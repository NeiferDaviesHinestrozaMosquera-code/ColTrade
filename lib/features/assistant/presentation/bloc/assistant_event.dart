import 'package:equatable/equatable.dart';

abstract class AssistantEvent extends Equatable {
  const AssistantEvent();

  @override
  List<Object> get props => [];
}

class LoadAssistantDataEvent extends AssistantEvent {}

class ContactAgentEvent extends AssistantEvent {
  final String agentId;
  final String type;
  final String message;

  const ContactAgentEvent({
    required this.agentId,
    required this.type,
    required this.message,
  });

  @override
  List<Object> get props => [agentId, type, message];
}

class ClassifyNandinaEvent extends AssistantEvent {
  final String query;

  const ClassifyNandinaEvent({required this.query});

  @override
  List<Object> get props => [query];
}
