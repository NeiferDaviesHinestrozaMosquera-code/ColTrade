import 'package:flutter_bloc/flutter_bloc.dart';
import 'erp_event.dart';
import 'erp_state.dart';

class ErpBloc extends Bloc<ErpEvent, ErpState> {
  ErpBloc() : super(ErpInitial()) {
    on<ConnectErpEvent>((event, emit) async {
      emit(ErpConnecting());
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(const ErpConnected());
      } catch (e) {
        emit(ErpError(message: e.toString()));
      }
    });
  }
}
