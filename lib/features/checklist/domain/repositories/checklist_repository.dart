import '../entities/doc_item_entity.dart';

abstract class ChecklistRepository {
  Future<List<DocItemEntity>> getChecklist();
}
