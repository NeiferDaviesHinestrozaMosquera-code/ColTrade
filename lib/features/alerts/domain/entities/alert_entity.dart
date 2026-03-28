import 'package:equatable/equatable.dart';

enum AlertPriority { alta, media, baja, informativo, tlc }

class AlertEntity extends Equatable {
  final AlertPriority priority;
  final String date;
  final String title;
  final String summary;
  final String institution;

  const AlertEntity({
    required this.priority,
    required this.date,
    required this.title,
    required this.summary,
    required this.institution,
  });

  @override
  List<Object> get props => [priority, date, title, summary, institution];
}
