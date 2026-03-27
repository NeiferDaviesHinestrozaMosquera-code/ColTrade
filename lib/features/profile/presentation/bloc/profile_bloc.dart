import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileDataEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        await Future.delayed(const Duration(milliseconds: 800));
        emit(const ProfileLoaded());
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    });
  }
}
