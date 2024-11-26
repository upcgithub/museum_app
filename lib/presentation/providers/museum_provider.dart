import 'package:flutter/foundation.dart';
import 'package:museum_app/core/services/museum_service.dart';

class MuseumProvider extends ChangeNotifier {
  final MuseumService _museumService;
  List<Map<String, dynamic>> popularArtworks = [];
  bool isLoading = false;

  MuseumProvider(this._museumService);

  Future<void> loadPopularArtworks() async {
    isLoading = true;
    notifyListeners();

    try {
      popularArtworks = await _museumService.getPopularArtworks();
    } catch (e) {
      debugPrint('Error loading artworks: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
