import 'package:equatable/equatable.dart';

class Agent extends Equatable {
  final String initials;
  final String name;
  final String agency;
  final String experience;
  final String city;
  final double rating;
  final List<String> specialties;
  final bool verified;
  final String bio;
  final List<String> certifications;
  final int reviewsCount;

  const Agent({
    required this.initials,
    required this.name,
    required this.agency,
    required this.experience,
    required this.city,
    required this.rating,
    required this.specialties,
    required this.verified,
    this.bio = 'Soy un experto en comercio internacional dedicado a optimizar tus procesos aduaneros, reducir costos logísticos y asegurar el cumplimiento normativo en cada una de tus operaciones.',
    this.certifications = const ['Operador Económico Autorizado (OEA)', 'BASC'],
    this.reviewsCount = 42,
  });

  @override
  List<Object?> get props => [
        initials,
        name,
        agency,
        experience,
        city,
        rating,
        specialties,
        verified,
        bio,
        certifications,
        reviewsCount,
      ];
}
