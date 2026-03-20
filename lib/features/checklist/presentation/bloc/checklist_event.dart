part of 'checklist_bloc.dart';

abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();

  @override
  List<Object> get props => [];
}

class LoadChecklist extends ChecklistEvent {
  const LoadChecklist();
}

class ChangeTab extends ChecklistEvent {
  final int tab;
  const ChangeTab(this.tab);

  @override
  List<Object> get props => [tab];
}

class ToggleDocument extends ChecklistEvent {
  final int index;
  const ToggleDocument(this.index);

  @override
  List<Object> get props => [index];
}
