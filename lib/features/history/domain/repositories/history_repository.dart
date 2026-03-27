import '../entities/history_item.dart';

abstract class HistoryRepository {
  Future<List<HistoryItem>> getHistoryItems();
}
