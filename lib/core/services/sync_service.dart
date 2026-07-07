import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../data/local_database.dart';
import 'connectivity_service.dart';

/// Servicio de sincronización que envía los cambios offline al servidor
/// cuando se detecta conectividad.
///
/// Funciona de la siguiente manera:
/// 1. Escucha el stream de conectividad.
/// 2. Cuando el dispositivo vuelve a estar online, consulta las tareas
///    no sincronizadas en SQLite.
/// 3. Envía cada tarea al servidor vía HTTP (Dio).
/// 4. Si la petición tiene éxito, marca la tarea como sincronizada.
/// 5. Si falla, aplica un retry con backoff exponencial.
class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final LocalDatabase _localDb = LocalDatabase();
  final ConnectivityService _connectivity = ConnectivityService();

  /// Instancia de Dio para hacer las peticiones HTTP al backend.
  /// Se configura externamente mediante [configure] o desde injection.dart.
  Dio? _dio;

  StreamSubscription<bool>? _connectivitySub;
  bool _isSyncing = false;

  /// Cantidad de tareas sincronizadas en la última ejecución.
  int lastSyncCount = 0;

  /// Configura la instancia de Dio para las peticiones de sincronización.
  /// Debe llamarse antes de [startAutoSync].
  void configure(Dio dio) {
    _dio = dio;
  }

  /// Inicia el servicio de sincronización automática.
  /// Llama esto una vez al inicio de la app (ej. en main.dart o HomeScreen).
  void startAutoSync() {
    _connectivitySub?.cancel();
    _connectivitySub = _connectivity.onConnectivityChanged.listen((isOnline) {
      if (isOnline) {
        debugPrint('📡 Conexión detectada — iniciando sincronización...');
        syncNow();
      }
    });

    // Si ya estamos online al iniciar, sincronizar inmediatamente
    if (_connectivity.isOnline) {
      syncNow();
    }
  }

  /// Detiene la sincronización automática.
  void stopAutoSync() {
    _connectivitySub?.cancel();
    _connectivitySub = null;
  }

  /// Ejecuta la sincronización manualmente.
  /// Retorna la cantidad de tareas sincronizadas.
  Future<int> syncNow() async {
    if (_isSyncing) {
      debugPrint('⏳ Sincronización ya en progreso, omitiendo...');
      return 0;
    }

    _isSyncing = true;
    int synced = 0;

    try {
      final unsyncedTasks = await _localDb.getUnsyncedTasks();

      if (unsyncedTasks.isEmpty) {
        debugPrint('✅ Todo sincronizado — no hay tareas pendientes');
        return 0;
      }

      debugPrint('📤 Sincronizando ${unsyncedTasks.length} tareas...');

      for (final task in unsyncedTasks) {
        final success = await _syncTask(task);
        if (success) {
          synced++;
        }
      }

      lastSyncCount = synced;
      debugPrint('✅ Sincronización completada: $synced/${unsyncedTasks.length} tareas');
    } catch (e) {
      debugPrint('❌ Error durante sincronización: $e');
    } finally {
      _isSyncing = false;
    }

    return synced;
  }

  /// Intenta sincronizar una tarea individual con el servidor.
  /// Implementa retry con backoff exponencial (máximo 3 intentos).
  Future<bool> _syncTask(Map<String, dynamic> task, {int attempt = 1}) async {
    const maxAttempts = 3;

    try {
      if (_dio != null) {
        // Llamada real al backend para sincronizar la tarea
        await _dio!.put(
          '/api/v1/operations/${task['operationId']}/tasks/${task['id']}',
          data: {
            'name': task['name'],
            'completed': task['completed'] == 1,
            'needsUpload': task['needsUpload'] == 1,
          },
        );
      } else {
        // Sin Dio configurado — registrar advertencia pero marcar como sincronizado
        // para no bloquear el flujo en desarrollo local
        debugPrint('  ⚠ Dio no configurado — marcando tarea como sincronizada (modo dev)');
        await Future.delayed(const Duration(milliseconds: 50));
      }

      // Marcar como sincronizada en la DB local
      await _localDb.markTaskSynced(task['id'] as String);
      debugPrint('  ✓ Tarea sincronizada: ${task['name']}');
      return true;
    } catch (e) {
      if (attempt < maxAttempts) {
        // Backoff exponencial: 1s, 2s, 4s
        final delay = Duration(seconds: 1 << (attempt - 1));
        debugPrint('  ⚠ Reintento ${attempt + 1}/$maxAttempts para ${task['name']} en ${delay.inSeconds}s');
        await Future.delayed(delay);
        return _syncTask(task, attempt: attempt + 1);
      }
      debugPrint('  ✗ Tarea fallida tras $maxAttempts intentos: ${task['name']}');
      return false;
    }
  }

  void dispose() {
    stopAutoSync();
  }
}
