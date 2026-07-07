import '../../domain/repositories/assistant_repository.dart';
import '../../../../core/data/local_database.dart';

class AssistantRepositoryImpl implements AssistantRepository {
  final LocalDatabase _localDb = LocalDatabase();

  @override
  Future<void> contactAgent(String agentId, String type, String message) async {
    // Simulating sending a message to the agent API with a reduced latency
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<Map<String, dynamic>> classifyNandinaProduct(String query) async {
    // Simulating search lookup processing delay
    await Future.delayed(const Duration(milliseconds: 400));

    final results = await _localDb.searchNandinaCode(query);
    if (results.isNotEmpty) {
      final bestMatch = results.first;
      return {
        'code': bestMatch['code'] as String,
        'match': bestMatch['matchPercent'] as int,
        'description': bestMatch['description'] as String,
        'justification': bestMatch['justification'] as String,
        'arancel': bestMatch['arancel'] as String,
        'iva': bestMatch['iva'] as String,
      };
    }

    // Dynamic fallback when query doesn't match predefined codes
    return {
      'code': '9900.00.00.00',
      'match': 65,
      'description': 'Mercancía genérica identificada como "$query".',
      'justification': 'La consulta arancelaria para "$query" no arrojó coincidencias exactas en la base de datos local de la DIAN. Se clasifica en la partida residual de otros artículos.',
      'arancel': '10%',
      'iva': '19%',
    };
  }
}
