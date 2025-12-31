import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:proyecto_moviles/models/communication_item.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('communication.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE communication_items (
        id TEXT PRIMARY KEY,
        text TEXT NOT NULL,
        icon_code INTEGER NOT NULL,
        color_value INTEGER NOT NULL,
        category TEXT NOT NULL,
        is_custom INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL
      )
    ''');

    // Insertar datos predefinidos
    await _insertDefaultData(db);
  }

  Future<void> _insertDefaultData(Database db) async {
    // Favoritos
    await db.insert('communication_items', {
      'id': 'si',
      'text': 'Sí',
      'icon_code': Icons.check_circle.codePoint,
      'color_value': Colors.green.value,
      'category': 'favoritos',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'no',
      'text': 'No',
      'icon_code': Icons.cancel.codePoint,
      'color_value': Colors.red.value,
      'category': 'favoritos',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'duele',
      'text': 'Me duele',
      'icon_code': Icons.healing.codePoint,
      'color_value': Colors.orange.value,
      'category': 'favoritos',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'ayuda',
      'text': 'Necesito ayuda',
      'icon_code': Icons.pan_tool.codePoint,
      'color_value': Colors.purple.value,
      'category': 'favoritos',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Comida
    await db.insert('communication_items', {
      'id': 'tengo_hambre',
      'text': 'Tengo hambre',
      'icon_code': Icons.restaurant.codePoint,
      'color_value': Colors.brown.value,
      'category': 'comida',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'tengo_sed',
      'text': 'Tengo sed',
      'icon_code': Icons.local_drink.codePoint,
      'color_value': Colors.blue.value,
      'category': 'comida',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'agua',
      'text': 'Quiero agua',
      'icon_code': Icons.water_drop.codePoint,
      'color_value': Colors.lightBlue.value,
      'category': 'comida',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'fruta',
      'text': 'Quiero fruta',
      'icon_code': Icons.apple.codePoint,
      'color_value': Colors.red.value,
      'category': 'comida',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'leche',
      'text': 'Quiero leche',
      'icon_code': Icons.coffee.codePoint,
      'color_value': 0xFFB0A696,
      'category': 'comida',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'terminé',
      'text': 'Ya terminé',
      'icon_code': Icons.done_all.codePoint,
      'color_value': Colors.green.value,
      'category': 'comida',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Emociones
    await db.insert('communication_items', {
      'id': 'feliz',
      'text': 'Estoy feliz',
      'icon_code': Icons.sentiment_very_satisfied.codePoint,
      'color_value': 0xFFFBC02D,
      'category': 'emociones',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'triste',
      'text': 'Estoy triste',
      'icon_code': Icons.sentiment_dissatisfied.codePoint,
      'color_value': Colors.blue.value,
      'category': 'emociones',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'enojado',
      'text': 'Estoy enojado',
      'icon_code': Icons.sentiment_very_dissatisfied.codePoint,
      'color_value': Colors.red.value,
      'category': 'emociones',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'asustado',
      'text': 'Tengo miedo',
      'icon_code': Icons.sentiment_neutral.codePoint,
      'color_value': Colors.purple.value,
      'category': 'emociones',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'cansado',
      'text': 'Estoy cansado',
      'icon_code': Icons.bedtime.codePoint,
      'color_value': Colors.indigo.value,
      'category': 'emociones',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'aburrido',
      'text': 'Estoy aburrido',
      'icon_code': Icons.access_time.codePoint,
      'color_value': Colors.grey.value,
      'category': 'emociones',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Necesidades
    await db.insert('communication_items', {
      'id': 'baño',
      'text': 'Quiero ir al baño',
      'icon_code': Icons.wc.codePoint,
      'color_value': Colors.teal.value,
      'category': 'necesidades',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'dolor',
      'text': 'Tengo dolor',
      'icon_code': Icons.medical_services.codePoint,
      'color_value': Colors.red.value,
      'category': 'necesidades',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'calor',
      'text': 'Tengo calor',
      'icon_code': Icons.thermostat.codePoint,
      'color_value': Colors.orange.value,
      'category': 'necesidades',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'frio',
      'text': 'Tengo frío',
      'icon_code': Icons.ac_unit.codePoint,
      'color_value': Colors.lightBlue.value,
      'category': 'necesidades',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'sueño',
      'text': 'Tengo sueño',
      'icon_code': Icons.bed.codePoint,
      'color_value': Colors.indigo.value,
      'category': 'necesidades',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('communication_items', {
      'id': 'descanso',
      'text': 'Quiero descansar',
      'icon_code': Icons.weekend.codePoint,
      'color_value': Colors.green.value,
      'category': 'necesidades',
      'is_custom': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Obtener items por categoría
  Future<List<CommunicationItem>> getItemsByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'communication_items',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'is_custom DESC, created_at DESC',
    );

    return result.map((json) => _itemFromJson(json)).toList();
  }

  // Obtener todos los items
  Future<List<CommunicationItem>> getAllItems() async {
    final db = await database;
    final result = await db.query('communication_items');
    return result.map((json) => _itemFromJson(json)).toList();
  }

  // Insertar nuevo item
  Future<CommunicationItem> insertItem(CommunicationItem item, String category) async {
    final db = await database;
    final itemData = _itemToJson(item);
    itemData['category'] = category; // Usar la categoría proporcionada
    await db.insert(
      'communication_items',
      itemData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return item;
  }

  // Actualizar item
  Future<int> updateItem(CommunicationItem item) async {
    final db = await database;
    return db.update(
      'communication_items',
      _itemToJson(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // Eliminar item (solo custom)
  Future<int> deleteItem(String id) async {
    final db = await database;
    return await db.delete(
      'communication_items',
      where: 'id = ? AND is_custom = 1',
      whereArgs: [id],
    );
  }

  // Verificar si un item es personalizado
  Future<bool> isCustomItem(String id) async {
    final db = await database;
    final result = await db.query(
      'communication_items',
      where: 'id = ? AND is_custom = 1',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  // Convertir de JSON a CommunicationItem
  CommunicationItem _itemFromJson(Map<String, dynamic> json) {
    return CommunicationItem(
      id: json['id'] as String,
      text: json['text'] as String,
      icon: IconData(json['icon_code'] as int, fontFamily: 'MaterialIcons'),
      color: Color(json['color_value'] as int),
    );
  }

  // Convertir de CommunicationItem a JSON
  Map<String, dynamic> _itemToJson(CommunicationItem item) {
    return {
      'id': item.id,
      'text': item.text,
      'icon_code': item.icon.codePoint,
      'color_value': item.color.value,
      'category': 'custom', // Las nuevas siempre son custom
      'is_custom': 1,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}