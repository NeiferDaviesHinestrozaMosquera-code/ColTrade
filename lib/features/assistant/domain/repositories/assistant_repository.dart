abstract class AssistantRepository {
  Future<void> contactAgent(String agentId, String type, String message);
  Future<Map<String, dynamic>> classifyNandinaProduct(String query);
}
