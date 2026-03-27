import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Utility class for password hashing using SHA-256.
/// In a real app, bcrypt or Argon2 would be used on the server side.
class PasswordHasher {
  PasswordHasher._();

  /// Returns a SHA-256 hex digest of [password].
  static String hash(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Checks if [plain] matches [hashed].
  static bool verify(String plain, String hashed) {
    return hash(plain) == hashed;
  }
}
