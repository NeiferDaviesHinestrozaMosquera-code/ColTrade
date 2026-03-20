import 'package:equatable/equatable.dart';

class DocItemEntity extends Equatable {
  final String name;
  final String entity;
  final bool completed;
  final bool needsUpload;
  final bool hasError;

  const DocItemEntity({
    required this.name,
    required this.entity,
    required this.completed,
    required this.needsUpload,
    this.hasError = false,
  });

  DocItemEntity copyWith({
    String? name,
    String? entity,
    bool? completed,
    bool? needsUpload,
    bool? hasError,
  }) =>
      DocItemEntity(
        name: name ?? this.name,
        entity: entity ?? this.entity,
        completed: completed ?? this.completed,
        needsUpload: needsUpload ?? this.needsUpload,
        hasError: hasError ?? this.hasError,
      );

  @override
  List<Object?> get props => [name, entity, completed, needsUpload, hasError];
}
