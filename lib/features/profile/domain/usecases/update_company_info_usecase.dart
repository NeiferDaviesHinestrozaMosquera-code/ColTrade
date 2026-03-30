import '../repositories/profile_repository.dart';

class UpdateCompanyInfoUseCase {
  final ProfileRepository repository;

  UpdateCompanyInfoUseCase(this.repository);

  Future<void> call(Map<String, dynamic> companyData) async {
    return await repository.updateCompanyInfo(companyData);
  }
}
