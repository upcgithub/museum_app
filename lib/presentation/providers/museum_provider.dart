import 'package:flutter/foundation.dart';
import 'package:museum_app/core/services/museum_service.dart';
import 'package:museum_app/domain/entities/artwork.dart';
import 'package:museum_app/core/dependency_injection/service_locator.dart';

class MuseumProvider extends ChangeNotifier {
  MuseumService? _museumService;
  bool isLoading = false;
  List<Artwork> popularArtworks = [];
  List<Artwork> whatsNewArtworks = [];
  List<Artwork> allArtworks = [];

  MuseumProvider() {
    // No inicializar inmediatamente, esperar a que el idioma esté disponible
  }

  // Método para inicializar después de que el idioma esté determinado
  Future<void> initializeWithLanguage(String languageCode) async {
    // Registrar MuseumService con el idioma correcto desde el inicio
    if (!getIt.isRegistered<MuseumService>()) {
      getIt.registerLazySingleton<MuseumService>(
          () => MuseumService(languageCode));
    }
    _museumService = getIt<MuseumService>();
    await _loadAllData();
  }

  Future<void> _loadAllData() async {
    await loadPopularArtworks();
    await loadWhatsNewArtworks();
    await loadAllArtworks();
  }

  Future<void> loadPopularArtworks() async {
    if (_museumService == null) return;

    isLoading = true;
    notifyListeners();

    try {
      popularArtworks = await _museumService!.getPopularArtworks();
    } catch (e) {
      // Log error instead of print for production
      debugPrint('Error loading popular artworks: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadWhatsNewArtworks() async {
    if (_museumService == null) return;

    isLoading = true;
    notifyListeners();

    try {
      whatsNewArtworks = await _museumService!.getWhatsNewArtworks();
    } catch (e) {
      debugPrint('Error loading new artworks: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadAllArtworks() async {
    if (_museumService == null) return;

    isLoading = true;
    notifyListeners();

    try {
      allArtworks = await _museumService!.getAllArtworks();
    } catch (e) {
      debugPrint('Error loading all artworks: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Artwork?> getArtworkById(String id) async {
    if (_museumService == null) return null;
    return await _museumService!.getArtworkById(id);
  }

  // Método para filtrar por tipo
  List<Artwork> getArtworksByType(String type) {
    return allArtworks.where((artwork) => artwork.type == type).toList();
  }

  // Método para buscar
  List<Artwork> searchArtworks(String query) {
    final lowerQuery = query.toLowerCase();
    return allArtworks.where((artwork) {
      return artwork.title.toLowerCase().contains(lowerQuery) ||
          artwork.artist.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Método para actualizar el idioma
  Future<void> updateLanguage(String languageCode) async {
    // Actualizar el service locator
    updateMuseumServiceLanguage(languageCode);
    // Obtener la nueva instancia
    _museumService = getIt<MuseumService>();
    await _loadAllData();
  }

  // Método para obtener el idioma actual del MuseumService
  String get currentLanguage {
    if (_museumService == null) return 'en';
    // Nota: El MuseumService no expone el idioma actual, pero podemos inferirlo
    // del estado del provider o usar la lógica del LanguageProvider
    return 'en'; // Simplificación - en producción usaríamos una mejor estrategia
  }
}
