import 'package:flutter/material.dart';
import 'package:museum_app/presentation/screens/artworks/artworks_screen.dart';
import 'package:museum_app/presentation/screens/home/home_screen.dart';
import 'package:museum_app/presentation/screens/artwork_detail/artwork_detail_screen.dart';
import 'package:museum_app/presentation/screens/saved/saved_screen.dart';
import 'package:museum_app/presentation/screens/auth/login_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String artworkDetail = '/artwork-detail';
  static const String saved = '/saved';
  static const String artworks = '/artworks';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case artworkDetail:
        final args = settings.arguments as Map<String, dynamic>;

        // Manejo seguro de relatedArtworks
        List<Map<String, dynamic>> relatedArtworks = [];
        if (args['relatedArtworks'] != null) {
          final rawList = args['relatedArtworks'] as List<dynamic>;
          relatedArtworks = rawList.cast<Map<String, dynamic>>();
        }

        return MaterialPageRoute(
          builder: (_) => ArtworkDetailScreen(
            id: args['id'] ?? '',
            title: args['title'] ?? 'Unknown Title',
            imageUrl: args['imageUrl'] ?? '',
            description: args['description'] ?? '',
            relatedArtworks: relatedArtworks,
            isViewed: args['isViewed'] ?? false,
          ),
        );
      case saved:
        return MaterialPageRoute(
          builder: (_) => const SavedScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case artworks:
        return MaterialPageRoute(
          builder: (_) => const ArtworksScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
    }
  }
}
