import '../../domain/entities/doc_item_entity.dart';
import '../../domain/repositories/checklist_repository.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  @override
  Future<List<DocItemEntity>> getChecklist() async {
    // Mock data – replace with API/local DB in production
    return const [
      DocItemEntity(
        name: 'Factura Comercial',
        entity: 'DIAN',
        completed: true,
        needsUpload: false,
      ),
      DocItemEntity(
        name: 'Lista de Empaque (Packing List)',
        entity: 'Empresa',
        completed: true,
        needsUpload: false,
      ),
      DocItemEntity(
        name: 'Certificado de Origen',
        entity: 'MINCIT',
        completed: false,
        needsUpload: true,
      ),
      DocItemEntity(
        name: 'Declaración de Exportación (DEX)',
        entity: 'DIAN',
        completed: false,
        needsUpload: false,
      ),
      DocItemEntity(
        name: 'Fitosanitario ICA',
        entity: 'ICA',
        completed: false,
        needsUpload: false,
        hasError: true,
      ),
    ];
  }
}
