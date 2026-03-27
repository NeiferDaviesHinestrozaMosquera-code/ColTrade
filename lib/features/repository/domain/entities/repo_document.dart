import 'package:equatable/equatable.dart';

enum DocCategory { aduanas, facturas, certificados, transporte, otros }

class RepoDocument extends Equatable {
  final String id;
  final String name;
  final String extension;
  final String size;
  final DateTime uploadDate;
  final DocCategory category;

  const RepoDocument({
    required this.id,
    required this.name,
    required this.extension,
    required this.size,
    required this.uploadDate,
    required this.category,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        extension,
        size,
        uploadDate,
        category,
      ];
}
