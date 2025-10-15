import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:museum_app/core/models/stylized_photo.dart';
import 'package:museum_app/core/services/stylized_photos_service.dart';

class StylizedPhotosProvider extends ChangeNotifier {
  final StylizedPhotosService _service;
  String? _currentUserId;

  List<StylizedPhoto> _photos = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  StylizedPhotosProvider(this._service);

  // Getters
  List<StylizedPhoto> get photos => _photos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get photoCount => _photos.length;
  bool get hasPhotos => _photos.isNotEmpty;
  bool get isInitialized => _isInitialized;

  /// Establecer el usuario actual
  void setCurrentUser(String? userId) {
    _currentUserId = userId;
    if (userId != null) {
      _initializeCount();
    } else {
      _photos = [];
      _isInitialized = false;
      notifyListeners();
    }
  }

  /// Initialize photo count (lightweight operation)
  Future<void> _initializeCount() async {
    if (_currentUserId == null) return;

    try {
      final count = await _service.getPhotoCount(_currentUserId!);
      // Just set a placeholder count without loading all photos
      log('📊 StylizedPhotosProvider: Initialized with $count photos for user: $_currentUserId');
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      log('❌ StylizedPhotosProvider: Error initializing count: $e');
    }
  }

  /// Load all photos for the current user
  Future<void> loadPhotos() async {
    if (_currentUserId == null) {
      log('⚠️ StylizedPhotosProvider: No user logged in');
      return;
    }

    // Prevent multiple simultaneous loads
    if (_isLoading) {
      log('⚠️ StylizedPhotosProvider: Already loading, skipping...');
      return;
    }

    log('📸 StylizedPhotosProvider: Loading photos for user: $_currentUserId');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _photos = await _service.getAllPhotos(_currentUserId!);
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
    if (_currentUserId == null) {
      _error = 'No user logged in';
      notifyListeners();
      return;
    }

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
    if (_currentUserId == null) {
      _error = 'No user logged in';
      notifyListeners();
      return;
    }

    log('🗑️ StylizedPhotosProvider: Deleting photo $id');
    try {
      await _service.deletePhoto(id, _currentUserId!);
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

  /// Clear all photos for the current user
  Future<void> clearAllPhotos() async {
    if (_currentUserId == null) {
      _error = 'No user logged in';
      notifyListeners();
      return;
    }

    log('🗑️ StylizedPhotosProvider: Clearing all photos for user: $_currentUserId');
    try {
      await _service.clearAllPhotos(_currentUserId!);
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
