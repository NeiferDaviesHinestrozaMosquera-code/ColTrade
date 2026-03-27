import 'package:equatable/equatable.dart';

abstract class AssistantEvent extends Equatable {
  const AssistantEvent();

  @override
  List<Object> get props => [];
}

class LoadAssistantDataEvent extends AssistantEvent {}
