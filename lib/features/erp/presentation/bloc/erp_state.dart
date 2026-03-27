import 'package:equatable/equatable.dart';

abstract class ErpState extends Equatable {
  const ErpState();

  @override
  List<Object> get props => [];
}

class ErpInitial extends ErpState {}

class ErpConnecting extends ErpState {}

class ErpConnected extends ErpState {
  const ErpConnected();

  @override
  List<Object> get props => [];
}

class ErpError extends ErpState {
  final String message;

  const ErpError({required this.message});

  @override
  List<Object> get props => [message];
}
