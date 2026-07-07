import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Servicio que monitorea el estado de conectividad de la red.
/// Expone un Stream<bool> para que otros servicios reaccionen
/// automáticamente cuando el dispositivo recupera la conexión.
///
/// Usa un enfoque ligero basado en DNS lookup en lugar de depender
/// de paquetes nativos pesados, maximizando la compatibilidad.
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final _controller = StreamController<bool>.broadcast();
  Timer? _pollingTimer;
  bool _lastKnownStatus = true;

  /// Stream que emite `true` cuando hay conexión y `false` cuando no.
  Stream<bool> get onConnectivityChanged => _controller.stream;

  /// Estado actual de conectividad (última lectura conocida).
  bool get isOnline => _lastKnownStatus;

  /// Inicia el monitoreo periódico de conectividad.
  /// Se recomienda llamar esto una sola vez en el inicio de la app.
  void startMonitoring({Duration interval = const Duration(seconds: 10)}) {
    _pollingTimer?.cancel();
    _checkConnectivity(); // Verificar inmediatamente
    _pollingTimer = Timer.periodic(interval, (_) => _checkConnectivity());
  }

  /// Detiene el monitoreo.
  void stopMonitoring() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Verifica la conectividad intentando resolver un hostname confiable.
  Future<void> _checkConnectivity() async {
    try {
      // Intentamos hacer un lookup de DNS básico
      // Si funciona, hay conectividad
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 5);
      final request = await client.getUrl(Uri.parse('https://dns.google'));
      final response = await request.close();
      await response.drain<void>();
      client.close();

      final online = response.statusCode < 500;

      if (online != _lastKnownStatus) {
        _lastKnownStatus = online;
        _controller.add(online);
        debugPrint('🌐 Conectividad: ${online ? "ONLINE" : "OFFLINE"}');
      }
    } catch (_) {
      if (_lastKnownStatus) {
        _lastKnownStatus = false;
        _controller.add(false);
        debugPrint('🌐 Conectividad: OFFLINE');
      }
    }
  }

  /// Fuerza una verificación inmediata de conectividad.
  Future<bool> checkNow() async {
    await _checkConnectivity();
    return _lastKnownStatus;
  }

  void dispose() {
    stopMonitoring();
    _controller.close();
  }
}
