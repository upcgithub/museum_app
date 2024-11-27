import 'package:flutter/foundation.dart';
import 'package:museum_app/core/services/museum_service.dart';
import 'package:museum_app/domain/entities/artwork.dart';

class MuseumProvider extends ChangeNotifier {
  final MuseumService _museumService;
  bool isLoading = false;
  List<Artwork> popularArtworks = [];
  List<Artwork> whatsNewArtworks = [];
  List<Artwork> allArtworks = [];

  MuseumProvider(this._museumService);

  Future<void> loadPopularArtworks() async {
    isLoading = true;
    notifyListeners();

    try {
      popularArtworks = await _museumService.getPopularArtworks();
    } catch (e) {
      print('Error loading popular artworks: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadWhatsNewArtworks() async {
    isLoading = true;
    notifyListeners();

    try {
      whatsNewArtworks = await _museumService.getWhatsNewArtworks();
    } catch (e) {
      print('Error loading new artworks: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadAllArtworks() async {
    isLoading = true;
    notifyListeners();

    try {
      allArtworks = await _museumService.getAllArtworks();
    } catch (e) {
      print('Error loading all artworks: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Artwork?> getArtworkById(String id) async {
    return await _museumService.getArtworkById(id);
  }
}
