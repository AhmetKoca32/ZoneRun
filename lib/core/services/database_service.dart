import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';
import '../models/polygon_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE polygons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        points TEXT NOT NULL,
        area REAL NOT NULL,
        created_at TEXT NOT NULL,
        completed_at TEXT
      )
    ''');
  }

  /// Insert a new polygon
  Future<int> insertPolygon(PolygonModel polygon) async {
    final db = await database;
    return await db.insert('polygons', polygon.toMap());
  }

  /// Get all polygons
  Future<List<PolygonModel>> getAllPolygons() async {
    final db = await database;
    final maps = await db.query('polygons', orderBy: 'created_at DESC');
    return maps.map((map) => PolygonModel.fromMap(map)).toList();
  }

  /// Get polygon by id
  Future<PolygonModel?> getPolygonById(int id) async {
    final db = await database;
    final maps = await db.query(
      'polygons',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return PolygonModel.fromMap(maps.first);
  }

  /// Update polygon
  Future<int> updatePolygon(PolygonModel polygon) async {
    final db = await database;
    return await db.update(
      'polygons',
      polygon.toMap(),
      where: 'id = ?',
      whereArgs: [polygon.id],
    );
  }

  /// Delete polygon
  Future<int> deletePolygon(int id) async {
    final db = await database;
    return await db.delete(
      'polygons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get completed polygons
  Future<List<PolygonModel>> getCompletedPolygons() async {
    final db = await database;
    final maps = await db.query(
      'polygons',
      where: 'completed_at IS NOT NULL',
      orderBy: 'completed_at DESC',
    );
    return maps.map((map) => PolygonModel.fromMap(map)).toList();
  }

  /// Get active (incomplete) polygons
  Future<List<PolygonModel>> getActivePolygons() async {
    final db = await database;
    final maps = await db.query(
      'polygons',
      where: 'completed_at IS NULL',
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => PolygonModel.fromMap(map)).toList();
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

