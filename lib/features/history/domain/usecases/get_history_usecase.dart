import '../entities/history_item.dart';
import '../repositories/history_repository.dart';

class GetHistoryUseCase {
  final HistoryRepository repository;

  GetHistoryUseCase(this.repository);

  Future<List<HistoryItem>> call() async {
    return await repository.getHistoryItems();
  }
}
