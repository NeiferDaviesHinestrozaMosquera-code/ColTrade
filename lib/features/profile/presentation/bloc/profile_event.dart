import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileDataEvent extends ProfileEvent {}

class UpdateCompanyProfileEvent extends ProfileEvent {
  final Map<String, dynamic> companyData;

  const UpdateCompanyProfileEvent(this.companyData);

  @override
  List<Object> get props => [companyData];
}
