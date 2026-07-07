import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/doc_item_entity.dart';

part 'checklist_event.dart';
part 'checklist_state.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  ChecklistBloc() : super(const ChecklistInitial()) {
    on<LoadChecklist>(_onLoad);
    on<ChangeTab>(_onChangeTab);
    on<ToggleDocument>(_onToggleDocument);
  }

  static final List<DocItemEntity> _initialDocs = [
    const DocItemEntity(
      name: 'Factura Comercial',
      entity: 'DIAN',
      completed: true,
      needsUpload: false,
    ),
    const DocItemEntity(
      name: 'Lista de Empaque (Packing List)',
      entity: 'Empresa',
      completed: true,
      needsUpload: false,
    ),
    const DocItemEntity(
      name: 'Certificado de Origen',
      entity: 'MINCIT',
      completed: false,
      needsUpload: true,
    ),
    const DocItemEntity(
      name: 'Declaración de Exportación (DEX)',
      entity: 'DIAN',
      completed: false,
      needsUpload: false,
    ),
    const DocItemEntity(
      name: 'Fitosanitario ICA',
      entity: 'ICA',
      completed: false,
      needsUpload: false,
      hasError: true,
    ),
  ];

  void _onLoad(LoadChecklist event, Emitter<ChecklistState> emit) {
    emit(ChecklistLoaded(docs: List.from(_initialDocs), selectedTab: 0));
  }

  void _onChangeTab(ChangeTab event, Emitter<ChecklistState> emit) {
    if (state is ChecklistLoaded) {
      emit((state as ChecklistLoaded).copyWith(selectedTab: event.tab));
    }
  }

  Future<void> _onToggleDocument(ToggleDocument event, Emitter<ChecklistState> emit) async {
    if (state is ChecklistLoaded) {
      final loaded = state as ChecklistLoaded;
      final previousDocs = List<DocItemEntity>.from(loaded.docs); // Backup

      // 1. Optimistic Update (Actualizar UI inmediatamente)
      final updatedDocs = List<DocItemEntity>.from(loaded.docs);
      final doc = updatedDocs[event.index];
      updatedDocs[event.index] = DocItemEntity(
        name: doc.name,
        entity: doc.entity,
        completed: !doc.completed,
        needsUpload: doc.needsUpload,
        hasError: doc.hasError,
      );
      
      emit(loaded.copyWith(docs: updatedDocs));

      // 2. Simular petición de red al servidor
      try {
        await Future.delayed(const Duration(milliseconds: 800));
        
        // Simular un fallo aleatorio del 20% para probar el rollback
        if (DateTime.now().millisecond % 5 == 0) {
          throw Exception('Error de conexión con el servidor (Simulado)');
        }
        
      } catch (e) {
        // 3. Rollback en caso de fallo
        emit(ChecklistError(message: e.toString().replaceAll('Exception: ', '')));
        // Restaurar el estado visual previo
        emit(loaded.copyWith(docs: previousDocs));
      }
    }
  }
}
