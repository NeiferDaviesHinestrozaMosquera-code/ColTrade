import 'package:flutter_bloc/flutter_bloc.dart';
import 'academy_event.dart';
import 'academy_state.dart';

class AcademyBloc extends Bloc<AcademyEvent, AcademyState> {
  AcademyBloc() : super(AcademyInitial()) {
    on<LoadCoursesEvent>((event, emit) async {
      emit(AcademyLoading());
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(const AcademyLoaded());
      } catch (e) {
        emit(AcademyError(message: e.toString()));
      }
    });
  }
}
