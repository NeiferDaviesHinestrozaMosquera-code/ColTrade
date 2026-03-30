import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sync_erp_usecase.dart';
import 'erp_event.dart';
import 'erp_state.dart';

class ErpBloc extends Bloc<ErpEvent, ErpState> {
  final SyncErpUseCase syncErp;

  ErpBloc({required this.syncErp}) : super(ErpInitial()) {
    on<ConnectErpEvent>((event, emit) async {
      emit(ErpConnecting());
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(const ErpConnected());
      } catch (e) {
        emit(ErpError(message: e.toString()));
      }
    });

    on<SyncErpDataEvent>((event, emit) async {
      emit(ErpSyncing());
      try {
        await syncErp();
        emit(ErpSyncSuccess());
      } catch (e) {
        emit(ErpSyncError(message: e.toString()));
      }
    });
  }
}
