part of 'home_bloc.dart';

class HomeState extends Equatable {
  final int selectedTab;

  const HomeState({this.selectedTab = 0});

  @override
  List<Object> get props => [selectedTab];
}
