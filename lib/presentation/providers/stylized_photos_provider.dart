import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:museum_app/core/models/stylized_photo.dart';
import 'package:museum_app/core/services/stylized_photos_service.dart';

class StylizedPhotosProvider extends ChangeNotifier {
  final StylizedPhotosService _service;

  List<StylizedPhoto> _photos = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  StylizedPhotosProvider(this._service) {
    // Load photos count on initialization (lightweight)
    _initializeCount();
  }

  // Getters
  List<StylizedPhoto> get photos => _photos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get photoCount => _photos.length;
  bool get hasPhotos => _photos.isNotEmpty;
  bool get isInitialized => _isInitialized;

  /// Initialize photo count (lightweight operation)
  Future<void> _initializeCount() async {
    try {
      final count = await _service.getPhotoCount();
      // Just set a placeholder count without loading all photos
      log('📊 StylizedPhotosProvider: Initialized with $count photos');
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      log('❌ StylizedPhotosProvider: Error initializing count: $e');
    }
  }

  /// Load all photos
  Future<void> loadPhotos() async {
    // Prevent multiple simultaneous loads
    if (_isLoading) {
      log('⚠️ StylizedPhotosProvider: Already loading, skipping...');
      return;
    }

    log('📸 StylizedPhotosProvider: Loading photos');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _photos = await _service.getAllPhotos();
      log('✅ StylizedPhotosProvider: Loaded ${_photos.length} photos');
    } catch (e) {
      log('❌ StylizedPhotosProvider: Error loading photos: $e');
      _error = 'Failed to load photos';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new photo
  Future<void> addPhoto(StylizedPhoto photo) async {
    log('➕ StylizedPhotosProvider: Adding photo ${photo.id}');
    try {
      await _service.savePhoto(photo);
      _photos.insert(0, photo); // Add to beginning (most recent first)
      log('✅ StylizedPhotosProvider: Photo added successfully');
      notifyListeners();
    } catch (e) {
      log('❌ StylizedPhotosProvider: Error adding photo: $e');
      _error = 'Failed to save photo';
      notifyListeners();
      rethrow;
    }
  }

  /// Delete a photo
  Future<void> deletePhoto(String id) async {
    log('🗑️ StylizedPhotosProvider: Deleting photo $id');
    try {
      await _service.deletePhoto(id);
      _photos.removeWhere((photo) => photo.id == id);
      log('✅ StylizedPhotosProvider: Photo deleted successfully');
      notifyListeners();
    } catch (e) {
      log('❌ StylizedPhotosProvider: Error deleting photo: $e');
      _error = 'Failed to delete photo';
      notifyListeners();
      rethrow;
    }
  }

  /// Get photos by artist
  List<StylizedPhoto> getPhotosByArtist(String artistName) {
    return _photos.where((photo) => photo.artistName == artistName).toList();
  }

  /// Get unique artists
  List<String> getUniqueArtists() {
    final artists = _photos.map((photo) => photo.artistName).toSet().toList();
    artists.sort();
    return artists;
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear all photos
  Future<void> clearAllPhotos() async {
    log('🗑️ StylizedPhotosProvider: Clearing all photos');
    try {
      await _service.clearAllPhotos();
      _photos.clear();
      log('✅ StylizedPhotosProvider: All photos cleared');
      notifyListeners();
    } catch (e) {
      log('❌ StylizedPhotosProvider: Error clearing photos: $e');
      _error = 'Failed to clear photos';
      notifyListeners();
      rethrow;
    }
  }
}
