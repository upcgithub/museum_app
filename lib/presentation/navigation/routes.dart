import 'package:flutter/material.dart';
import 'package:museum_app/presentation/screens/artworks/artworks_screen.dart';
import 'package:museum_app/presentation/screens/home/home_screen.dart';
import 'package:museum_app/presentation/screens/artwork_detail/artwork_detail_screen.dart';
import 'package:museum_app/presentation/screens/saved/saved_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String artworkDetail = '/artwork-detail';
  static const String saved = '/saved';
  static const String artworks = '/artworks';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case artworkDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ArtworkDetailScreen(
            id: args['id'],
            title: args['title'],
            imageUrl: args['imageUrl'],
            description: args['description'],
            relatedArtworks: args['relatedArtworks'],
            isViewed: args['isViewed'] ?? false,
          ),
        );
      case saved:
        return MaterialPageRoute(
          builder: (_) => const SavedScreen(),
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
