part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class ChangeHomeTab extends HomeEvent {
  final int tab;
  const ChangeHomeTab(this.tab);

  @override
  List<Object> get props => [tab];
}
