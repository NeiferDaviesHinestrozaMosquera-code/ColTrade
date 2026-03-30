import '../../domain/repositories/erp_repository.dart';

class ErpRepositoryImpl implements ErpRepository {
  @override
  Future<void> syncErpData() async {
    // Simulate integration delay with backend
    await Future.delayed(const Duration(seconds: 2));
  }
}
