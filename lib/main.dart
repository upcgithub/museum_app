import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:museum_app/core/services/database_service.dart';
import 'package:museum_app/core/services/supabase_config.dart';
import 'package:museum_app/core/services/gemini_service.dart';
import 'package:museum_app/core/services/stylized_photos_service.dart';
import 'package:museum_app/presentation/providers/saved_artworks_provider.dart';
import 'package:museum_app/presentation/providers/auth_provider.dart';
import 'package:museum_app/presentation/providers/gemini_provider.dart';
import 'package:museum_app/presentation/providers/stylized_photos_provider.dart';
import 'package:provider/provider.dart';
import 'package:museum_app/presentation/app.dart';
import 'package:museum_app/core/dependency_injection/service_locator.dart';
import 'package:museum_app/presentation/providers/museum_provider.dart';
import 'package:museum_app/presentation/providers/language_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  log('🚀 App: Starting Culture Connect app...');
  WidgetsFlutterBinding.ensureInitialized();
  log('✅ App: Flutter binding initialized');

  // Load environment variables
  log('📄 App: Loading .env file...');
  await dotenv.load(fileName: '.env');
  log('✅ App: Environment variables loaded');
  log('   GEMINI_API_KEY present: ${dotenv.env.containsKey('GEMINI_API_KEY')}');

  // Inicializar Supabase
  log('🔧 App: Initializing Supabase...');
  await SupabaseConfig.initialize();
  log('✅ App: Supabase initialized');

  log('🔧 App: Setting up service locator...');
  setupServiceLocator();
  log('✅ App: Service locator setup complete');

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
        ChangeNotifierProvider(
          create: (_) {
            log('🎨 App: Creating GeminiProvider...');
            final service = GeminiService();
            final provider = GeminiProvider(service);
            log('✅ App: GeminiProvider created');
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            log('📸 App: Creating StylizedPhotosProvider...');
            final provider =
                StylizedPhotosProvider(getIt<StylizedPhotosService>());
            log('✅ App: StylizedPhotosProvider created');
            return provider;
          },
        ),
      ],
      child: const MuseumApp(),
    ),
  );

  log('🎉 App: All providers initialized, app running!');
}
