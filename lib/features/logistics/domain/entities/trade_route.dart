import 'package:equatable/equatable.dart';

enum TransportMode { sea, air, land, multimodal }

class TradeRoute extends Equatable {
  final String id;
  final String originPortId;
  final String originName;
  final String destinationName;
  final String destinationCountry;
  final String destinationFlag;
  final TransportMode mode;
  final int minTransitDays;
  final int maxTransitDays;
  final String frequency;
  final String description;
  final double estimatedFreightUsd;
  final List<String> mainCarriers;
  final List<String> keyProducts;

  const TradeRoute({
    required this.id,
    required this.originPortId,
    required this.originName,
    required this.destinationName,
    required this.destinationCountry,
    required this.destinationFlag,
    required this.mode,
    required this.minTransitDays,
    required this.maxTransitDays,
    required this.frequency,
    required this.description,
    required this.estimatedFreightUsd,
    required this.mainCarriers,
    required this.keyProducts,
  });

  @override
  List<Object?> get props =>
      [id, originPortId, destinationName, destinationCountry, mode];
}
