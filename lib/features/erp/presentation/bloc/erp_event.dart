import 'package:equatable/equatable.dart';

abstract class ErpEvent extends Equatable {
  const ErpEvent();

  @override
  List<Object> get props => [];
}

class ConnectErpEvent extends ErpEvent {}

class SyncErpDataEvent extends ErpEvent {}
