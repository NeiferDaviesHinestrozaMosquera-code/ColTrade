import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_company_info_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateCompanyInfoUseCase updateCompanyInfo;

  ProfileBloc({required this.updateCompanyInfo}) : super(ProfileInitial()) {
    on<LoadProfileDataEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        await Future.delayed(const Duration(milliseconds: 800));
        emit(const ProfileLoaded());
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    });

    on<UpdateCompanyProfileEvent>((event, emit) async {
      emit(ProfileUpdating());
      try {
        await updateCompanyInfo(event.companyData);
        emit(ProfileUpdateSuccess());
      } catch (e) {
        emit(ProfileUpdateError(message: e.toString()));
      }
    });
  }
}
