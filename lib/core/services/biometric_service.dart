import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Servicio que encapsula la autenticación biométrica (FaceID / Huella).
class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Verifica si el dispositivo tiene sensores biométricos disponibles.
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheck && isDeviceSupported;
    } on PlatformException {
      return false;
    }
  }

  /// Obtiene la lista de biométricos disponibles (huella, rostro, etc).
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Solicita autenticación biométrica al usuario.
  /// Devuelve `true` si se autenticó correctamente.
  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Usa tu huella o rostro para ingresar a ColTrade',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }
}
