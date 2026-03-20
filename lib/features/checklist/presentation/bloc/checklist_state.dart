part of 'checklist_bloc.dart';

abstract class ChecklistState extends Equatable {
  const ChecklistState();

  @override
  List<Object> get props => [];
}

class ChecklistInitial extends ChecklistState {
  const ChecklistInitial();
}

class ChecklistLoaded extends ChecklistState {
  final List<DocItemEntity> docs;
  final int selectedTab;

  const ChecklistLoaded({
    required this.docs,
    required this.selectedTab,
  });

  double get progress {
    if (docs.isEmpty) return 0;
    return docs.where((d) => d.completed).length / docs.length;
  }

  ChecklistLoaded copyWith({
    List<DocItemEntity>? docs,
    int? selectedTab,
  }) {
    return ChecklistLoaded(
      docs: docs ?? this.docs,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object> get props => [docs, selectedTab];
}
