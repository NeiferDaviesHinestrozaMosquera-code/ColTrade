import '../repositories/assistant_repository.dart';

class ContactAgentUseCase {
  final AssistantRepository repository;

  ContactAgentUseCase(this.repository);

  Future<void> call({
    required String agentId,
    required String type,
    required String message,
  }) async {
    return await repository.contactAgent(agentId, type, message);
  }
}
