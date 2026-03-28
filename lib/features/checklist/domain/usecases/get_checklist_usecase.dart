import '../../../../core/usecases/usecase.dart';
import '../entities/doc_item_entity.dart';
import '../repositories/checklist_repository.dart';

class GetChecklistUseCase {
  final ChecklistRepository repository;

  GetChecklistUseCase(this.repository);

  Future<List<DocItemEntity>> call(NoParams params) => repository.getChecklist();
}
