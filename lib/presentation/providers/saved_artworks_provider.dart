import 'package:flutter/foundation.dart';
import 'package:museum_app/core/services/database_service.dart';
import 'package:museum_app/core/models/saved_artwork.dart';
import 'package:museum_app/domain/entities/artwork.dart';

class SavedArtworksProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  String? _currentUserId;

  List<SavedArtwork> _savedArtworks = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<SavedArtwork> get savedArtworks => _savedArtworks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  SavedArtworksProvider(this._databaseService);

  /// Establecer el usuario actual
  void setCurrentUser(String? userId) {
    _currentUserId = userId;
    if (userId != null) {
      loadSavedArtworks();
    } else {
      _savedArtworks = [];
      notifyListeners();
    }
  }

  /// Cargar todas las obras guardadas del usuario actual
  Future<void> loadSavedArtworks() async {
    if (_currentUserId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _savedArtworks =
          await _databaseService.getAllSavedArtworks(_currentUserId!);
    } catch (e) {
      _error = 'Error loading saved artworks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Guardar una obra de arte
  Future<void> saveArtwork(Artwork artwork) async {
    if (_currentUserId == null) {
      _error = 'No user logged in';
      notifyListeners();
      return;
    }

    try {
      final savedArtwork = SavedArtwork(
        id: artwork.id, // Usar el mismo ID del Artwork
        title: artwork.title,
        artist: artwork.artist,
        imageUrl: artwork.imageUrl,
        description: artwork.description ?? '',
        savedAt: DateTime.now(),
        userId: _currentUserId!,
      );

      await _databaseService.saveArtwork(savedArtwork);

      // Actualizar la lista local SIN consultar de nuevo la BD
      _savedArtworks.add(savedArtwork);
      notifyListeners(); // ¡Actualización INSTANTÁNEA!
    } catch (e) {
      _error = 'Error saving artwork: $e';
      notifyListeners();
    }
  }

  /// Eliminar una obra guardada
  Future<void> removeSavedArtwork(String title) async {
    if (_currentUserId == null) {
      _error = 'No user logged in';
      notifyListeners();
      return;
    }

    try {
      await _databaseService.deleteArtwork(title, _currentUserId!);

      // Actualizar la lista local SIN consultar de nuevo la BD
      _savedArtworks.removeWhere((artwork) => artwork.title == title);
      notifyListeners(); // ¡Actualización INSTANTÁNEA!
    } catch (e) {
      _error = 'Error removing artwork: $e';
      notifyListeners();
    }
  }

  /// Verificar si una obra está guardada
  bool isArtworkSaved(String title) {
    return _savedArtworks.any((artwork) => artwork.title == title);
  }

  /// Toggle save/unsave
  Future<void> toggleSaveArtwork(Artwork artwork) async {
    if (isArtworkSaved(artwork.title)) {
      await removeSavedArtwork(artwork.title);
    } else {
      await saveArtwork(artwork);
    }
  }
}
