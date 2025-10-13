import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:museum_app/domain/entities/artwork.dart';

class MuseumService {
  final String _currentLanguage;

  MuseumService(this._currentLanguage);

  Future<List<Artwork>> getPopularArtworks() async {
    final String fileName = 'assets/data/artworks_$_currentLanguage.json';
    final String jsonString = await rootBundle.loadString(fileName);
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((data) => Artwork.fromMap(data)).toList();
  }

  Future<List<Artwork>> getWhatsNewArtworks() async {
    final String fileName = 'assets/data/whats_new_$_currentLanguage.json';
    final String jsonString = await rootBundle.loadString(fileName);
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((data) => Artwork.fromMap(data)).toList();
  }

  // Método unificado para obtener todas las obras de arte
  Future<List<Artwork>> getAllArtworks() async {
    final popularArtworks = await getPopularArtworks();
    final whatsNewArtworks = await getWhatsNewArtworks();

    return [...popularArtworks, ...whatsNewArtworks];
  }

  // Método para obtener una obra de arte por ID
  Future<Artwork?> getArtworkById(String id) async {
    try {
      final artworks = await getAllArtworks();
      return artworks.firstWhere((artwork) => artwork.id == id);
    } catch (e) {
      return null;
    }
  }

  // Método para obtener obras de arte filtradas por tipo
  Future<List<Artwork>> getArtworksByType(String type) async {
    final artworks = await getAllArtworks();
    return artworks.where((artwork) => artwork.type == type).toList();
  }

  // Método para buscar obras de arte por título o artista
  Future<List<Artwork>> searchArtworks(String query) async {
    final artworks = await getAllArtworks();
    final lowerQuery = query.toLowerCase();

    return artworks.where((artwork) {
      return artwork.title.toLowerCase().contains(lowerQuery) ||
          artwork.artist.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Método para obtener idiomas disponibles (para futura migración a Supabase)
  List<String> getSupportedLanguages() {
    return ['en', 'es'];
  }

  // Método para cambiar el idioma (para futura migración a Supabase)
  Future<MuseumService> withLanguage(String language) async {
    return MuseumService(language);
  }
}
