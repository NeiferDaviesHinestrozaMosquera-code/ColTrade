import 'package:equatable/equatable.dart';

enum PortType { sea, air, river }

class Port extends Equatable {
  final String id;
  final String name;
  final String city;
  final String country;
  final PortType type;
  final double lat;
  final double lon;
  final String capacity;
  final String description;
  final String emoji;
  final List<String> tradePartners;
  final String iataCode;

  const Port({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.type,
    required this.lat,
    required this.lon,
    required this.capacity,
    required this.description,
    required this.emoji,
    required this.tradePartners,
    this.iataCode = '',
  });

  @override
  List<Object?> get props =>
      [id, name, city, country, type, lat, lon, iataCode];
}
