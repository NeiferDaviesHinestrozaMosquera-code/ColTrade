import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Utility class for password hashing using SHA-256 with salt.
/// In a real app, bcrypt or Argon2 would be used on the server side.
class PasswordHasher {
  PasswordHasher._();

  static final _random = Random.secure();

  /// Generates a cryptographically secure random salt (16 bytes, hex-encoded).
  static String _generateSalt([int length = 16]) {
    final bytes = List<int>.generate(length, (_) => _random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Returns a salted SHA-256 hex digest of [password] in format `salt:hash`.
  static String hash(String password, {String? salt}) {
    final usedSalt = salt ?? _generateSalt();
    final bytes = utf8.encode('$usedSalt$password');
    final digest = sha256.convert(bytes);
    return '$usedSalt:${digest.toString()}';
  }

  /// Checks if [plain] matches the salted [hashedWithSalt] (format `salt:hash`).
  static bool verify(String plain, String hashedWithSalt) {
    final parts = hashedWithSalt.split(':');
    if (parts.length != 2) return false;
    final salt = parts[0];
    return hash(plain, salt: salt) == hashedWithSalt;
  }
}
