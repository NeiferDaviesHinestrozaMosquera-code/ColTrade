import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Singleton que administra la base de datos local SQLite para modo offline.
class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  factory LocalDatabase() => _instance;
  LocalDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'coltrade_offline.db');

    return openDatabase(
      path,
      version: 3, // Incrementado a 3 para soportar las nuevas tablas de documentos, historial y nandina
      onCreate: (db, version) async {
        // Tabla para tareas del checklist (modo offline)
        await db.execute('''
          CREATE TABLE checklist_tasks (
            id TEXT PRIMARY KEY,
            operationId TEXT NOT NULL,
            name TEXT NOT NULL,
            entity TEXT NOT NULL,
            completed INTEGER DEFAULT 0,
            needsUpload INTEGER DEFAULT 0,
            hasError INTEGER DEFAULT 0,
            syncedAt TEXT,
            updatedAt TEXT
          )
        ''');

        // Tabla para historial de chat IA (offline cache)
        await db.execute('''
          CREATE TABLE chat_messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sessionId TEXT NOT NULL,
            role TEXT NOT NULL,
            content TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');

        // Tabla de caché de API con TTL
        await db.execute('''
          CREATE TABLE api_cache (
            cacheKey TEXT PRIMARY KEY,
            responseJson TEXT NOT NULL,
            expiresAt TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');

        // Tabla de documentos
        await db.execute('''
          CREATE TABLE documents (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            extension TEXT NOT NULL,
            size TEXT NOT NULL,
            uploadDate TEXT NOT NULL,
            category TEXT NOT NULL
          )
        ''');

        // Tabla de historial de consultas
        await db.execute('''
          CREATE TABLE history_items (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            subtitle TEXT NOT NULL,
            date TEXT NOT NULL,
            category TEXT NOT NULL,
            importance TEXT NOT NULL
          )
        ''');

        // Tabla de partidas arancelarias Nandina
        await db.execute('''
          CREATE TABLE nandina_codes (
            code TEXT PRIMARY KEY,
            matchPercent INTEGER NOT NULL,
            description TEXT NOT NULL,
            justification TEXT NOT NULL,
            arancel TEXT NOT NULL,
            iva TEXT NOT NULL
          )
        ''');

        // Pre-poblar los códigos Nandina
        await _prepopulateNandina(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS api_cache (
              cacheKey TEXT PRIMARY KEY,
              responseJson TEXT NOT NULL,
              expiresAt TEXT NOT NULL,
              createdAt TEXT NOT NULL
            )
          ''');
        }
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS documents (
              id TEXT PRIMARY KEY,
              name TEXT NOT NULL,
              extension TEXT NOT NULL,
              size TEXT NOT NULL,
              uploadDate TEXT NOT NULL,
              category TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS history_items (
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              subtitle TEXT NOT NULL,
              date TEXT NOT NULL,
              category TEXT NOT NULL,
              importance TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS nandina_codes (
              code TEXT PRIMARY KEY,
              matchPercent INTEGER NOT NULL,
              description TEXT NOT NULL,
              justification TEXT NOT NULL,
              arancel TEXT NOT NULL,
              iva TEXT NOT NULL
            )
          ''');

          await _prepopulateNandina(db);
        }
      },
    );
  }

  Future<void> _prepopulateNandina(Database db) async {
    final batch = db.batch();
    
    final codes = [
      {
        'code': '0901.11.00.00',
        'matchPercent': 98,
        'description': 'Café sin tostar, sin descafeinar (Café Verde).',
        'justification': 'Clasificado en el Capítulo 9 (Café, té, yerba mate y especias), partida 0901, subpartida 0901.11.00.00 por tratarse de café en grano verde sin procesos adicionales de tostado ni descafeinado.',
        'arancel': '15%',
        'iva': '19%',
      },
      {
        'code': '0804.40.00.00',
        'matchPercent': 95,
        'description': 'Aguacates (paltas), frescos o secos (Aguacate Hass).',
        'justification': 'Clasificado en el Capítulo 8 (Frutas y frutos comestibles), partida 0804, subpartida 0804.40.00.00 por tratarse de aguacate fresco de la variedad Hass.',
        'arancel': '15%',
        'iva': '0%',
      },
      {
        'code': '5208.11.00.00',
        'matchPercent': 92,
        'description': 'Tejidos de algodón con un contenido de algodón superior o igual al 85% en peso, de gramaje inferior o igual a 200 g/m².',
        'justification': 'Clasificado en la Sección XI (Materias textiles y sus manufacturas), Capítulo 52 (Algodón), partida 5208. Se selecciona la subpartida por el peso y composición del tejido.',
        'arancel': '15%',
        'iva': '19%',
      },
      {
        'code': '8429.51.00.00',
        'matchPercent': 94,
        'description': 'Cargadoras y palas cargadoras de carga frontal (Maquinaria Pesada).',
        'justification': 'Clasificado en el Capítulo 84 (Reactores nucleares, calderas, máquinas, aparatos y artefactos mecánicos), partida 8429 (Topadoras, niveladoras, excavadoras), subpartida 8429.51.00.00.',
        'arancel': '5%',
        'iva': '19%',
      },
      {
        'code': '8471.30.00.00',
        'matchPercent': 96,
        'description': 'Máquinas automáticas para tratamiento o procesamiento de datos, portátiles, de peso inferior o igual a 10 kg, que consten por lo menos de una unidad central de proceso, un teclado y una pantalla (Computadores / Electrónicos).',
        'justification': 'Clasificado en el Capítulo 84, partida 8471 para máquinas de procesamiento de datos portátiles (laptops/tablets) que cumplen con los requisitos de peso y componentes.',
        'arancel': '0%',
        'iva': '19%',
      },
      {
        'code': '6403.59.00.00',
        'matchPercent': 98,
        'description': 'Los demás calzados con suela de caucho, plástico, cuero natural o regenerado y parte superior de cuero natural (Calzado de cuero).',
        'justification': 'La clasificación se realizó basándose en las características del calzado con parte superior de cuero natural y suela de caucho/plástico/cuero.',
        'arancel': '15%',
        'iva': '19%',
      }
    ];

    for (final item in codes) {
      batch.insert(
        'nandina_codes',
        item,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  // ── Operaciones de Checklist ──────────────────────────────────────────────

  /// Inserta una lista de tareas en la base de datos local.
  Future<void> insertTasks(String operationId, List<Map<String, dynamic>> tasks) async {
    final db = await database;
    final batch = db.batch();
    for (final task in tasks) {
      batch.insert(
        'checklist_tasks',
        {
          'id': task['id'] ?? '${operationId}_${tasks.indexOf(task)}',
          'operationId': operationId,
          'name': task['name'],
          'entity': task['entity'],
          'completed': task['completed'] == true ? 1 : 0,
          'needsUpload': task['needsUpload'] == true ? 1 : 0,
          'hasError': task['hasError'] == true ? 1 : 0,
          'syncedAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// Obtiene las tareas del checklist para una operación específica.
  Future<List<Map<String, dynamic>>> getTasks(String operationId) async {
    final db = await database;
    return db.query(
      'checklist_tasks',
      where: 'operationId = ?',
      whereArgs: [operationId],
    );
  }

  /// Actualiza el estado de completado de una tarea.
  Future<void> updateTaskCompletion(String taskId, bool completed) async {
    final db = await database;
    await db.update(
      'checklist_tasks',
      {
        'completed': completed ? 1 : 0,
        'syncedAt': null, // Marcar como no sincronizado
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  /// Obtiene las tareas que han sido modificadas localmente y aún no sincronizadas.
  Future<List<Map<String, dynamic>>> getUnsyncedTasks() async {
    final db = await database;
    return db.query(
      'checklist_tasks',
      where: 'syncedAt IS NULL',
    );
  }

  /// Marca una tarea como sincronizada con el servidor.
  Future<void> markTaskSynced(String taskId) async {
    final db = await database;
    await db.update(
      'checklist_tasks',
      {'syncedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  // ── Operaciones de Chat ───────────────────────────────────────────────────

  Future<void> saveChatMessage(String sessionId, String role, String content) async {
    final db = await database;
    await db.insert('chat_messages', {
      'sessionId': sessionId,
      'role': role,
      'content': content,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getChatHistory(String sessionId) async {
    final db = await database;
    return db.query(
      'chat_messages',
      where: 'sessionId = ?',
      whereArgs: [sessionId],
      orderBy: 'createdAt ASC',
    );
  }

  // ── Operaciones de Caché de API ───────────────────────────────────────────

  /// Obtiene una respuesta cacheada si existe y no ha expirado.
  Future<String?> getCachedResponse(String cacheKey) async {
    final db = await database;
    final results = await db.query(
      'api_cache',
      where: 'cacheKey = ? AND expiresAt > ?',
      whereArgs: [cacheKey, DateTime.now().toIso8601String()],
    );
    if (results.isEmpty) return null;
    return results.first['responseJson'] as String;
  }

  /// Almacena una respuesta en caché con un TTL en segundos.
  Future<void> setCachedResponse(String cacheKey, String responseJson, int ttlSeconds) async {
    final db = await database;
    final expiresAt = DateTime.now().add(Duration(seconds: ttlSeconds));
    await db.insert(
      'api_cache',
      {
        'cacheKey': cacheKey,
        'responseJson': responseJson,
        'expiresAt': expiresAt.toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Limpia todas las entradas expiradas de la caché.
  Future<int> clearExpiredCache() async {
    final db = await database;
    return db.delete(
      'api_cache',
      where: 'expiresAt <= ?',
      whereArgs: [DateTime.now().toIso8601String()],
    );
  }

  /// Limpia toda la caché de API.
  Future<void> clearAllCache() async {
    final db = await database;
    await db.delete('api_cache');
  }

  // ── Operaciones de Documentos ──────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getDocuments() async {
    final db = await database;
    return db.query('documents', orderBy: 'uploadDate DESC');
  }

  Future<void> insertDocument(Map<String, dynamic> doc) async {
    final db = await database;
    await db.insert(
      'documents',
      doc,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteDocument(String id) async {
    final db = await database;
    await db.delete(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ── Operaciones de Historial ──────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getHistoryItems() async {
    final db = await database;
    return db.query('history_items', orderBy: 'date DESC');
  }

  Future<void> insertHistoryItem(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert(
      'history_items',
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ── Operaciones de Partidas Nandina ────────────────────────────────────────

  Future<List<Map<String, dynamic>>> searchNandinaCode(String query) async {
    final db = await database;
    // Búsqueda LIKE simple en descripción o código
    return db.query(
      'nandina_codes',
      where: 'description LIKE ? OR code LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
  }
}
