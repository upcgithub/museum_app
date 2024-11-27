import 'package:flutter/material.dart';
import 'package:museum_app/core/services/museum_service.dart';
import 'package:provider/provider.dart';
import 'package:museum_app/presentation/app.dart';
import 'package:museum_app/core/dependency_injection/service_locator.dart';
import 'package:museum_app/presentation/providers/museum_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MuseumProvider(getIt<MuseumService>()),
        ),
      ],
      child: const MuseumApp(),
    ),
  );
}
