import 'package:equatable/equatable.dart';

class SessionEntity extends Equatable {
  final String id;
  final String device;
  final String location;
  final String time;
  final bool isCurrent;
  final String iconType; // 'phone' | 'computer'

  const SessionEntity({
    required this.id,
    required this.device,
    required this.location,
    required this.time,
    required this.isCurrent,
    required this.iconType,
  });

  @override
  List<Object?> get props => [id, device, location, time, isCurrent, iconType];
}
