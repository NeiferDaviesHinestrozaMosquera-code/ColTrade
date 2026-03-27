import 'package:equatable/equatable.dart';

abstract class AcademyEvent extends Equatable {
  const AcademyEvent();

  @override
  List<Object> get props => [];
}

class LoadCoursesEvent extends AcademyEvent {}
