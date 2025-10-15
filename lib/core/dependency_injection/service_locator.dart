import 'package:get_it/get_it.dart';
import 'package:museum_app/core/services/museum_service.dart';
import 'package:museum_app/core/services/database_service.dart';
import 'package:museum_app/core/services/auth_service.dart';
import 'package:museum_app/core/services/supabase_config.dart';
import 'package:museum_app/core/services/stylized_photos_service.dart';
import 'package:museum_app/domain/repositories/auth_repository.dart';
import 'package:museum_app/domain/usecases/auth_usecases.dart';
import 'package:museum_app/data/repositories/auth_repository_impl.dart';
import 'package:flutter/material.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Services - Database first (no dependencies)
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService.instance);

  // Stylized Photos Service
  getIt.registerLazySingleton<StylizedPhotosService>(
      () => StylizedPhotosService());

  // Supabase configuration
  getIt.registerLazySingleton<SupabaseConfig>(() => SupabaseConfig());

  // Auth Service
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthService>()));

  // Auth Use Cases
  getIt.registerLazySingleton<AuthUseCases>(
      () => AuthUseCases(getIt<AuthRepository>()));
}

// Factory method to create MuseumService with correct language
MuseumService createMuseumService(BuildContext context) {
  // This will be called after LanguageProvider is available
  // We'll use the current locale from LanguageProvider
  return MuseumService('en'); // Temporal, será reemplazado por el idioma real
}

// Método para actualizar el idioma del MuseumService
void updateMuseumServiceLanguage(String languageCode) {
  // Reemplazar la instancia existente con una nueva que tenga el idioma correcto
  getIt.unregister<MuseumService>();
  getIt.registerLazySingleton<MuseumService>(() => MuseumService(languageCode));
}
