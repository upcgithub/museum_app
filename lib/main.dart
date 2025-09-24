import 'package:flutter/material.dart';
import 'package:museum_app/core/services/museum_service.dart';
import 'package:museum_app/core/services/database_service.dart';
import 'package:museum_app/presentation/providers/saved_artworks_provider.dart';
import 'package:provider/provider.dart';
import 'package:museum_app/presentation/app.dart';
import 'package:museum_app/core/dependency_injection/service_locator.dart';
import 'package:museum_app/presentation/providers/museum_provider.dart';
import 'package:museum_app/presentation/providers/language_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MuseumProvider(getIt<MuseumService>()),
        ),
        ChangeNotifierProvider(
          create: (_) => SavedArtworksProvider(getIt<DatabaseService>()),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),
      ],
      child: const MuseumApp(),
    ),
  );
}
