import 'package:equatable/equatable.dart';

enum HistoryCategory { aranceles, cotizacion, checklist, rutas, otros }
enum HistoryImportance { alta, media, baja }

class HistoryItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final HistoryCategory category;
  final HistoryImportance importance;

  const HistoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.category,
    required this.importance,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        date,
        category,
        importance,
      ];
}
