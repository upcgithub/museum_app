import 'dart:io';
import 'dart:developer';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:museum_app/core/models/stylized_photo.dart';

class StylizedPhotosService {
  static Database? _database;
  static const String _tableName = 'stylized_photos';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    log('🗄️ StylizedPhotosService: Initializing database');
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = path.join(documentsDirectory.path, 'stylized_photos.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        log('🗄️ StylizedPhotosService: Creating table $_tableName');
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            filePath TEXT NOT NULL,
            artistName TEXT NOT NULL,
            artworkTitle TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            thumbnailPath TEXT
          )
        ''');
      },
    );
  }

  /// Get the directory for storing stylized photos
  Future<Directory> getPhotosDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(path.join(appDir.path, 'stylized_photos'));

    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
      log('📁 StylizedPhotosService: Created photos directory: ${photosDir.path}');
    }

    return photosDir;
  }

  /// Save a stylized photo
  Future<StylizedPhoto> savePhoto(StylizedPhoto photo) async {
    log('💾 StylizedPhotosService: Saving photo ${photo.id}');
    final db = await database;

    await db.insert(
      _tableName,
      photo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    log('✅ StylizedPhotosService: Photo saved successfully');
    return photo;
  }

  /// Get all stylized photos
  Future<List<StylizedPhoto>> getAllPhotos() async {
    log('📖 StylizedPhotosService: Getting all photos');
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'createdAt DESC',
    );

    log('✅ StylizedPhotosService: Found ${maps.length} photos');
    return List.generate(maps.length, (i) => StylizedPhoto.fromMap(maps[i]));
  }

  /// Get photos by artist
  Future<List<StylizedPhoto>> getPhotosByArtist(String artistName) async {
    log('📖 StylizedPhotosService: Getting photos by artist: $artistName');
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'artistName = ?',
      whereArgs: [artistName],
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) => StylizedPhoto.fromMap(maps[i]));
  }

  /// Delete a photo
  Future<void> deletePhoto(String id) async {
    log('🗑️ StylizedPhotosService: Deleting photo $id');
    final db = await database;

    // Get photo to delete file
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final photo = StylizedPhoto.fromMap(maps.first);

      // Delete file
      final file = File(photo.filePath);
      if (await file.exists()) {
        await file.delete();
        log('🗑️ StylizedPhotosService: Deleted file: ${photo.filePath}');
      }

      // Delete thumbnail if exists
      if (photo.thumbnailPath != null) {
        final thumbFile = File(photo.thumbnailPath!);
        if (await thumbFile.exists()) {
          await thumbFile.delete();
        }
      }
    }

    // Delete from database
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    log('✅ StylizedPhotosService: Photo deleted successfully');
  }

  /// Get photo count
  Future<int> getPhotoCount() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Clear all photos
  Future<void> clearAllPhotos() async {
    log('🗑️ StylizedPhotosService: Clearing all photos');
    final db = await database;

    // Get all photos to delete files
    final photos = await getAllPhotos();
    for (final photo in photos) {
      final file = File(photo.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      if (photo.thumbnailPath != null) {
        final thumbFile = File(photo.thumbnailPath!);
        if (await thumbFile.exists()) {
          await thumbFile.delete();
        }
      }
    }

    // Clear database
    await db.delete(_tableName);
    log('✅ StylizedPhotosService: All photos cleared');
  }
}
