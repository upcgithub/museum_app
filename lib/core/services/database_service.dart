import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/saved_artwork.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('museum.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Incrementar versión para migración
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_artworks(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        description TEXT NOT NULL,
        savedAt TEXT NOT NULL
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migrar de int id a String id
      await db.execute('DROP TABLE IF EXISTS saved_artworks');
      await _createDB(db, newVersion);
    }
  }

  Future<SavedArtwork> saveArtwork(SavedArtwork artwork) async {
    final db = await instance.database;
    await db.insert(
      'saved_artworks',
      artwork.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Reemplazar si ya existe
    );
    return artwork;
  }

  Future<List<SavedArtwork>> getAllSavedArtworks() async {
    final db = await instance.database;
    final result = await db.query('saved_artworks', orderBy: 'savedAt DESC');
    return result.map((json) => SavedArtwork.fromMap(json)).toList();
  }

  Future<bool> isArtworkSaved(String title) async {
    final db = await instance.database;
    final result = await db.query(
      'saved_artworks',
      where: 'title = ?',
      whereArgs: [title],
    );
    return result.isNotEmpty;
  }

  Future<int> deleteArtwork(String title) async {
    final db = await instance.database;
    return await db.delete(
      'saved_artworks',
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  // Método adicional para eliminar por ID
  Future<int> deleteArtworkById(String id) async {
    final db = await instance.database;
    return await db.delete(
      'saved_artworks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
