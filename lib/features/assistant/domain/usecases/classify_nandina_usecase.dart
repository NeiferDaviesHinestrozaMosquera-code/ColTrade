import '../repositories/assistant_repository.dart';

class ClassifyNandinaUseCase {
  final AssistantRepository repository;

  ClassifyNandinaUseCase(this.repository);

  Future<Map<String, dynamic>> call(String query) async {
    return await repository.classifyNandinaProduct(query);
  }
}
