import 'package:equatable/equatable.dart';
import 'trade_route.dart';

class LogisticsAlternative extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final TransportMode mode;
  final List<String> pros;
  final List<String> cons;
  final String estimatedCostRange;
  final int minDays;
  final int maxDays;
  final String bestFor;
  final String emoji;

  const LogisticsAlternative({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.mode,
    required this.pros,
    required this.cons,
    required this.estimatedCostRange,
    required this.minDays,
    required this.maxDays,
    required this.bestFor,
    required this.emoji,
  });

  @override
  List<Object?> get props => [id, title, mode];
}
