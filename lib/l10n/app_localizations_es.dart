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
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get rememberMe => 'Recordarme';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get logInButton => 'Iniciar Sesión';

  @override
  String get orLoginWith => 'O ingresa con';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get signUp => 'Registrarse';

  @override
  String get registerTitle => 'Crear Cuenta';

  @override
  String get firstNameLabel => 'Nombre';

  @override
  String get lastNameLabel => 'Apellido';

  @override
  String get confirmPasswordLabel => 'Confirmar Contraseña';

  @override
  String get acceptTerms => 'Acepto los Términos y Condiciones';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta?';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get orSignUpWith => 'O regístrate con';

  @override
  String get signupAgreementPrefix => 'Al registrarte, aceptas los ';

  @override
  String get signupAgreementConjunction => ' y el ';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get dataProcessingAgreement => 'Acuerdo de Tratamiento de Datos';

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
  String get profileEmail => 'jane@gmail.com';

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

  @override
  String get captchaInstruction => 'Selecciona los íconos alfabéticamente';

  @override
  String get captchaSolved => 'Verificado';

  @override
  String get captchaReset => 'Probar con otra secuencia';

  @override
  String get captchaMuseumLabel => 'Museo';

  @override
  String get captchaPaletteLabel => 'Paleta';

  @override
  String get captchaTheaterLabel => 'Teatro';

  @override
  String get aiFeaturesTitle => 'Funciones de IA';

  @override
  String get playAudioGuide => 'Reproducir Guía de Audio';

  @override
  String get playAudioGuideDesc => 'Escucha la narración sobre esta obra';

  @override
  String chatWithArtist(String artist) {
    return 'Conversa con $artist';
  }

  @override
  String get chatWithArtistDesc => 'Haz preguntas sobre esta obra';

  @override
  String get stylizeYourPhoto => 'Estiliza tu Foto';

  @override
  String stylizeYourPhotoDesc(String artist) {
    return 'Transforma una foto al estilo de $artist';
  }

  @override
  String get sendMessage => 'Enviar mensaje';

  @override
  String get typeYourQuestion => 'Escribe tu pregunta...';

  @override
  String applyingStyle(String artist) {
    return 'Aplicando el estilo de $artist...';
  }

  @override
  String get selectPhoto => 'Seleccionar Foto';

  @override
  String get shareStylizedImage => 'Compartir';

  @override
  String get downloadImage => 'Descargar';

  @override
  String get originalImage => 'Original';

  @override
  String get stylizedImage => 'Estilizada';

  @override
  String get chatError => 'Error al enviar mensaje. Inténtalo de nuevo.';

  @override
  String get styleTransferError =>
      'Error al estilizar imagen. Inténtalo de nuevo.';

  @override
  String get qrScannerTitle => 'Escáner QR';

  @override
  String get qrScannerInstruction =>
      'Apunta la cámara hacia el código QR\nde la obra de arte';

  @override
  String get qrScannerKeepInArea =>
      'Mantén el código dentro\ndel área de escaneo';

  @override
  String artistStyle(String artist) {
    return 'Estilo de $artist';
  }

  @override
  String get gallery => 'Galería';

  @override
  String get camera => 'Cámara';

  @override
  String get thisMayTakeAMoment => 'Esto puede tomar un momento...';

  @override
  String get tryAgain => 'Intentar de Nuevo';

  @override
  String imageStylizedSuccessfully(String artist) {
    return '¡Imagen estilizada exitosamente usando el estilo artístico de $artist!';
  }

  @override
  String get aiStyleTransferGuide => 'Guía de Transferencia de Estilo IA';

  @override
  String aiStyleGuideNote(String artist) {
    return 'Nota: Esta es una guía de estilo generada por IA para el enfoque artístico de $artist.';
  }

  @override
  String get tryAnother => 'Intentar con Otra';

  @override
  String get share => 'Compartir';

  @override
  String get save => 'Guardar';

  @override
  String get imageSaved => '¡Imagen guardada exitosamente!';

  @override
  String get imageSharedSuccessfully => '¡Imagen compartida exitosamente!';

  @override
  String get shareError =>
      'Error al compartir la imagen. Por favor, intenta de nuevo.';

  @override
  String get saveError =>
      'Error al guardar la imagen. Por favor, intenta de nuevo.';

  @override
  String get passwordResetEmailSent =>
      'Se ha enviado un correo para restablecer tu contraseña';

  @override
  String get pleaseEnterValidEmail =>
      'Por favor ingresa un correo electrónico válido';

  @override
  String get stylizedGallery => 'Galería Estilizada';

  @override
  String photosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fotos',
      one: 'foto',
      zero: 'fotos',
    );
    return '$count $_temp0';
  }

  @override
  String get all => 'Todas';

  @override
  String noPhotosForArtist(String artist) {
    return 'No hay fotos de $artist';
  }

  @override
  String get noStylizedPhotosYet => 'Aún No Hay Fotos Estilizadas';

  @override
  String get createYourFirstStylizedPhoto =>
      '¡Crea tu primera foto estilizada explorando obras de arte y usando la función de transferencia de estilo con IA!';

  @override
  String get startCreating => 'Empezar a Crear';

  @override
  String get deletePhoto => 'Eliminar Foto';

  @override
  String get deletePhotoConfirmation =>
      '¿Estás seguro de que deseas eliminar esta foto? Esta acción no se puede deshacer.';

  @override
  String get delete => 'Eliminar';

  @override
  String get photoDeleted => 'Foto eliminada exitosamente';

  @override
  String get stylizedPhotos => 'Fotos Estilizadas';
}
