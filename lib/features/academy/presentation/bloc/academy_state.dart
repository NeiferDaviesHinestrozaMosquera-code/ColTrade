import 'package:equatable/equatable.dart';

abstract class AcademyState extends Equatable {
  const AcademyState();

  @override
  List<Object> get props => [];
}

class AcademyInitial extends AcademyState {}

class AcademyLoading extends AcademyState {}

class AcademyLoaded extends AcademyState {
  const AcademyLoaded();

  @override
  List<Object> get props => [];
}

class AcademyError extends AcademyState {
  final String message;

  const AcademyError({required this.message});

  @override
  List<Object> get props => [message];
}
