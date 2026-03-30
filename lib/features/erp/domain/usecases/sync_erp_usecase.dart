import '../repositories/erp_repository.dart';

class SyncErpUseCase {
  final ErpRepository repository;

  SyncErpUseCase(this.repository);

  Future<void> call() async {
    return await repository.syncErpData();
  }
}
