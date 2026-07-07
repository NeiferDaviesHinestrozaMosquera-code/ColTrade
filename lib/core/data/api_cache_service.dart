import 'dart:convert';
import 'local_database.dart';

/// Servicio de caché de API que almacena respuestas en SQLite con TTL.
/// Permite respuestas instantáneas en pantallas previamente visitadas
/// sin necesidad de ir al servidor.
///
/// Uso:
/// ```dart
/// final data = await apiCache.cachedRequest(
///   key: 'operations_list_page1',
///   ttlSeconds: 300, // 5 minutos
///   fetcher: () => dio.get('/operations?page=1'),
/// );
/// ```
class ApiCacheService {
  final LocalDatabase _db = LocalDatabase();

  /// TTL por defecto: 5 minutos
  static const int defaultTtl = 300;

  /// Obtiene datos de caché si están disponibles y no han expirado.
  /// Si no hay caché válida, ejecuta el [fetcher], guarda el resultado y lo devuelve.
  ///
  /// [key] — Clave única para identificar la petición (ej. 'operations_page1').
  /// [fetcher] — Función que realiza la petición HTTP real.
  /// [ttlSeconds] — Tiempo de vida de la caché en segundos.
  /// [forceRefresh] — Si es true, ignora la caché y ejecuta el fetcher.
  Future<T> cachedRequest<T>({
    required String key,
    required Future<T> Function() fetcher,
    int ttlSeconds = defaultTtl,
    bool forceRefresh = false,
  }) async {
    // 1. Intentar obtener de caché (si no se fuerza el refresh)
    if (!forceRefresh) {
      final cached = await _db.getCachedResponse(key);
      if (cached != null) {
        return jsonDecode(cached) as T;
      }
    }

    // 2. Ejecutar la petición real
    final result = await fetcher();

    // 3. Guardar en caché
    try {
      await _db.setCachedResponse(key, jsonEncode(result), ttlSeconds);
    } catch (_) {
      // Si falla el guardado en caché, no es crítico
    }

    return result;
  }

  /// Invalida una clave específica de la caché.
  /// Útil cuando el usuario acaba de crear/actualizar un recurso.
  Future<void> invalidate(String key) async {
    final db = await _db.database;
    await db.delete('api_cache', where: 'cacheKey = ?', whereArgs: [key]);
  }

  /// Invalida todas las claves que empiezan con un prefijo.
  /// Ej: invalidatePrefix('operations_') limpia toda la caché de operaciones.
  Future<void> invalidatePrefix(String prefix) async {
    final db = await _db.database;
    await db.delete('api_cache', where: 'cacheKey LIKE ?', whereArgs: ['$prefix%']);
  }

  /// Limpia las entradas expiradas de la caché (mantenimiento).
  Future<int> cleanup() async {
    return _db.clearExpiredCache();
  }

  /// Limpia toda la caché.
  Future<void> clearAll() async {
    return _db.clearAllCache();
  }
}
