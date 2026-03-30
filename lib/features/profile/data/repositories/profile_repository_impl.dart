import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<void> updateCompanyInfo(Map<String, dynamic> companyData) async {
    // Simulate integration delay with backend
    await Future.delayed(const Duration(milliseconds: 900));
  }
}
