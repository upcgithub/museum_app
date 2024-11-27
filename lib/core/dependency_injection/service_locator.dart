import 'package:get_it/get_it.dart';
import 'package:museum_app/core/services/museum_service.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Services
  getIt.registerLazySingleton<MuseumService>(() => MuseumService());
}
