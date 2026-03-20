import '../../../../core/usecases/usecase.dart';
import '../entities/doc_item_entity.dart';
import '../repositories/checklist_repository.dart';

class GetChecklistUseCase implements UseCase<List<DocItemEntity>, NoParams> {
  final ChecklistRepository repository;

  GetChecklistUseCase(this.repository);

  @override
  Future<List<DocItemEntity>> call(NoParams params) =>
      repository.getChecklist();
}
