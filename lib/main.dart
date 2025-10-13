import 'package:flutter/material.dart';
import 'package:museum_app/core/services/database_service.dart';
import 'package:museum_app/core/services/supabase_config.dart';
import 'package:museum_app/presentation/providers/saved_artworks_provider.dart';
import 'package:museum_app/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:museum_app/presentation/app.dart';
import 'package:museum_app/core/dependency_injection/service_locator.dart';
import 'package:museum_app/presentation/providers/museum_provider.dart';
import 'package:museum_app/presentation/providers/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await SupabaseConfig.initialize();

  setupServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),
        // MuseumProvider se crea después de que LanguageProvider determine el idioma
        ChangeNotifierProvider(
          create: (context) {
            final languageProvider = context.read<LanguageProvider>();

            // Crear MuseumProvider (no inicializar aún)
            final provider = MuseumProvider();

            // Inicializar inmediatamente con el idioma correcto
            // (esto es seguro porque LanguageProvider ya detectó el idioma del dispositivo)
            provider.initializeWithLanguage(
                languageProvider.currentLocale.languageCode);

            // Escuchar cambios en el idioma y actualizar el MuseumService
            languageProvider.addListener(() {
              // Actualizar el idioma del MuseumService
              updateMuseumServiceLanguage(
                  languageProvider.currentLocale.languageCode);
              // Actualizar el provider
              provider
                  .updateLanguage(languageProvider.currentLocale.languageCode);
            });

            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => SavedArtworksProvider(getIt<DatabaseService>()),
        ),
      ],
      child: const MuseumApp(),
    ),
  );
}
