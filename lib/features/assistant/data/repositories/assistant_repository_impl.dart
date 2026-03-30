import '../../domain/repositories/assistant_repository.dart';

class AssistantRepositoryImpl implements AssistantRepository {
  @override
  Future<void> contactAgent(String agentId, String type, String message) async {
    // Simulating sending a message to the agent API
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<Map<String, dynamic>> classifyNandinaProduct(String query) async {
    // Simulating an LLM or database search
    await Future.delayed(const Duration(seconds: 2));
    return {
      'code': '6403.59.00.00',
      'match': 98,
      'description':
          'Los demás calzados con suela de caucho, plástico, cuero natural o regenerado y parte superior de cuero natural.',
      'justification':
          'La clasificación se realizó basándose en las características del producto: material de la suela (cuero natural), tipo de calzado y uso final. Se excluyeron partidas como 6401 (calzado impermeable) y 6402 (suela de caucho o plástico) por no aplicar las características mencionadas.',
      'arancel': '15%',
      'iva': '19%',
    };
  }
}
