// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Museo App';

  @override
  String get home => 'Inicio';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Ajustes';

  @override
  String get premiumMember => 'Miembro Premium';

  @override
  String get profileName => 'Jane Doe';

  @override
  String get profileEmail => 'jane.doe@example.com';

  @override
  String get savedArtworks => 'Obras Guardadas';

  @override
  String get tickets => 'Entradas';

  @override
  String get exhibitions => 'Exposiciones';

  @override
  String get qrScans => 'Escaneos QR';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get languagePreferences => 'Preferencias de Idioma';

  @override
  String get accessibilitySettings => 'Ajustes de Accesibilidad';

  @override
  String get notificationSettings => 'Ajustes de Notificaciones';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get logoutConfirmation =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get artQuote =>
      'El arte nos permite encontrarnos y perdernos al mismo tiempo.';

  @override
  String get location => 'Ubicación';

  @override
  String get limaPeru => 'Lima, Perú';

  @override
  String get searchExhibitionsEvents => 'Buscar exposiciones, eventos...';

  @override
  String get exhibition => 'Exposición';

  @override
  String get events => 'Eventos';

  @override
  String get artwork => 'Obra de Arte';

  @override
  String get artist => 'Artista';

  @override
  String get popular => 'Popular';

  @override
  String get viewAll => 'Ver Todo';

  @override
  String get whatsNew => 'Novedades';

  @override
  String get artworks => 'Obras de Arte';

  @override
  String get noArtworksFound => 'No se encontraron obras de arte';

  @override
  String get loadingSavedArtworks => 'Cargando obras guardadas...';

  @override
  String get retry => 'Reintentar';

  @override
  String get noSavedArtworksYet => 'Aún no hay obras guardadas';

  @override
  String get startExploringAndSave =>
      '¡Comienza a explorar y guarda tus obras favoritas!';

  @override
  String get remove => 'Eliminar';

  @override
  String get removeFromSaved => 'Eliminar de Guardados';

  @override
  String areYouSureRemove(String artworkTitle) {
    return '¿Estás seguro de que quieres eliminar \"$artworkTitle\" de tus obras guardadas?';
  }

  @override
  String artworkRemovedFromSaved(String artworkTitle) {
    return '$artworkTitle eliminada de guardados';
  }

  @override
  String artworkSavedToCollection(String artworkTitle) {
    return '$artworkTitle guardada en tu colección';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String get undoFunctionalityComingSoon =>
      '¡La funcionalidad de deshacer llegará pronto!';

  @override
  String savedOn(String date) {
    return 'Guardado el $date';
  }

  @override
  String get ticketsScreen => 'Pantalla de Entradas';

  @override
  String get playAudio => 'Reproducir Audio';

  @override
  String get pauseAudio => 'Pausar Audio';

  @override
  String get relatedArtworks => 'Obras Relacionadas';

  @override
  String get saveArtwork => 'Guardar Obra';

  @override
  String get removeFromSavedArtworks => 'Eliminar de Obras Guardadas';

  @override
  String get readMore => 'Leer más';

  @override
  String get readLess => 'Leer menos';

  @override
  String get relatedToThisArtwork => 'Relacionado con esta obra';

  @override
  String get viewed => 'Visto';
}
