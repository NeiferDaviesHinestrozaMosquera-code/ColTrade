import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String docType;
  final String docNumber;
  final String role;
  final String city;

  const AuthUserEntity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.docType,
    required this.docNumber,
    required this.role,
    required this.city,
  });

  @override
  List<Object> get props =>
      [fullName, email, phone, docType, docNumber, role, city];
}
