import '../../domain/entities/history_item.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDatasource datasource;

  HistoryRepositoryImpl(this.datasource);

  @override
  Future<List<HistoryItem>> getHistoryItems() async {
    return await datasource.getHistoryItems();
  }
}
