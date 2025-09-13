# 🏛️ Culture Connect - Aplicación de Museo

Una aplicación móvil moderna desarrollada en Flutter que permite a los usuarios explorar obras de arte, exhibiciones y experiencias interactivas en museos.

## 📋 Tabla de Contenidos

- [Descripción General](#-descripción-general)
- [Arquitectura](#-arquitectura)
- [Tecnologías y Dependencias](#-tecnologías-y-dependencias)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Manejo de Estado](#-manejo-de-estado)
- [Características Principales](#-características-principales)
- [Configuración e Instalación](#-configuración-e-instalación)
- [Mejoras Recomendadas](#-mejoras-recomendadas)
- [Problemas Identificados](#-problemas-identificados)
- [Roadmap de Mejoras](#-roadmap-de-mejoras)

## 🎯 Descripción General

Culture Connect es una aplicación de museo que ofrece una experiencia inmersiva para explorar arte y cultura. Los usuarios pueden:

- Explorar obras de arte populares y nuevas
- Escanear códigos QR para obtener información detallada
- Guardar sus obras favoritas
- Escuchar audioguías
- Gestionar tickets y perfil personal
- Navegar por exhibiciones y eventos

**Estado Actual**: Aplicación funcional con funcionalidades básicas implementadas, pero con oportunidades significativas de mejora en el manejo de estado y arquitectura.

## 🏗️ Arquitectura

La aplicación sigue una **arquitectura por capas híbrida** que combina elementos de Clean Architecture con algunos patrones menos estructurados:

### Capas Actuales:

```
lib/
├── core/                    # Servicios y utilidades centrales
│   ├── dependency_injection/ # Inyección de dependencias (GetIt)
│   ├── models/              # Modelos de datos locales
│   ├── services/            # Servicios de negocio
│   └── theme/               # Tema y estilos
├── domain/                  # Entidades de dominio
│   └── entities/            # Modelos de dominio
├── presentation/            # Capa de presentación
│   ├── navigation/          # Navegación y rutas
│   ├── providers/           # Manejo de estado (Provider)
│   ├── screens/             # Pantallas de la aplicación
│   └── widgets/             # Widgets reutilizables
└── l10n/                    # Internacionalización
```

### Patrones Utilizados:

- **Repository Pattern**: Parcialmente implementado en servicios
- **Provider Pattern**: Para manejo de estado global
- **Service Locator**: Con GetIt para inyección de dependencias
- **MVVM**: Implícito con Provider como ViewModel

## 📦 Tecnologías y Dependencias

### Dependencias Principales:

```yaml
# Framework y UI
flutter: sdk
flutter_localizations: sdk
google_fonts: ^6.1.0
flutter_svg: ^2.0.9

# Manejo de Estado
provider: ^6.1.1

# Inyección de Dependencias
get_it: ^7.6.7

# Networking
dio: ^5.4.0

# Base de Datos Local
sqflite: ^2.3.0
path: ^1.8.3

# Funcionalidades Específicas
flutter_barcode_scanner: ^2.0.0 # Escaneo QR
cached_network_image: ^3.3.1 # Caché de imágenes
audioplayers: ^5.2.1 # Reproductor de audio

# Internacionalización
intl: ^0.19.0
```

### Dependencias de Desarrollo:

```yaml
flutter_test: sdk
flutter_lints: ^2.0.0
build_runner: ^2.4.8
```

### Análisis de Dependencias:

**✅ Fortalezas:**

- Uso de packages estables y bien mantenidos
- Configuración correcta de internacionalización
- Implementación de caché para imágenes

**⚠️ Áreas de Mejora:**

- Falta de manejo de errores robusto (considerar `dartz` para Either)
- Sin logging estructurado (considerar `logger`)
- Sin testing avanzado (considerar `mockito`, `bloc_test`)

## 📁 Estructura del Proyecto

### Organización de Archivos:

```
culture_connect/
├── android/                 # Configuración Android
├── ios/                     # Configuración iOS
├── assets/                  # Recursos estáticos
│   ├── audio/              # Archivos de audio para audioguías
│   ├── fonts/              # Fuentes personalizadas (Playfair, Urbanist)
│   └── images/             # Imágenes y logos
├── lib/
│   ├── core/
│   │   ├── dependency_injection/
│   │   │   └── service_locator.dart    # Configuración GetIt
│   │   ├── models/
│   │   │   └── saved_artwork.dart      # Modelo para obras guardadas
│   │   ├── services/
│   │   │   ├── database_service.dart   # Servicio SQLite
│   │   │   └── museum_service.dart     # Servicio de datos del museo
│   │   └── theme/
│   │       ├── app_colors.dart         # Colores de la app
│   │       └── app_text_styles.dart    # Estilos de texto
│   ├── domain/
│   │   └── entities/
│   │       └── artwork.dart            # Entidad Artwork
│   ├── presentation/
│   │   ├── navigation/
│   │   │   ├── main_navigation.dart    # Navegación principal
│   │   │   └── routes.dart             # Definición de rutas
│   │   ├── providers/
│   │   │   └── museum_provider.dart    # Provider principal
│   │   ├── screens/
│   │   │   ├── artwork_detail/         # Detalle de obra
│   │   │   ├── artworks/              # Lista de obras
│   │   │   ├── home/                  # Pantalla principal
│   │   │   ├── profile/               # Perfil de usuario
│   │   │   ├── saved/                 # Obras guardadas
│   │   │   └── tickets/               # Tickets
│   │   └── widgets/
│   │       ├── artwork_card.dart       # Card de obra
│   │       └── scan_button.dart        # Botón de escaneo
│   └── l10n/
│       ├── app_en.arb                 # Textos en inglés
│       └── app_es.arb                 # Textos en español
├── pubspec.yaml                       # Configuración del proyecto
└── README.md                          # Este archivo
```

## 🔄 Manejo de Estado

### Estado Actual:

La aplicación utiliza **Provider** como solución de manejo de estado, pero con **implementación inconsistente**:

#### ✅ Correctamente Implementado:

**HomeScreen**: Usa Provider correctamente

```dart
// Inicialización en initState
Future.microtask(() {
  final provider = context.read<MuseumProvider>();
  provider.loadPopularArtworks();
  provider.loadWhatsNewArtworks();
});

// Consumo reactivo en build
Consumer<MuseumProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) {
      return CircularProgressIndicator();
    }
    // ... resto del widget
  },
)
```

**ArtworksScreen**: También implementado correctamente

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<MuseumProvider>().loadAllArtworks();
  });
}
```

#### ❌ Problemas Identificados:

1. **SavedScreen**: NO usa Provider

   - Usa `FutureBuilder` directamente con `DatabaseService`
   - No mantiene estado reactivo
   - Requiere recreación manual del widget para actualizarse

2. **ArtworkDetailScreen**: Manejo de estado local inconsistente

   - Usa `setState` para manejo local (correcto)
   - Pero no notifica cambios globales al guardar/desguardar obras

3. **TicketsScreen**: Completamente vacía

4. **ProfileScreen**: No usa Provider para datos dinámicos

### Provider Actual (MuseumProvider):

```dart
class MuseumProvider extends ChangeNotifier {
  final MuseumService _museumService;
  bool isLoading = false;
  List<Artwork> popularArtworks = [];
  List<Artwork> whatsNewArtworks = [];
  List<Artwork> allArtworks = [];

  // Métodos para cargar diferentes tipos de obras
  Future<void> loadPopularArtworks() async { ... }
  Future<void> loadWhatsNewArtworks() async { ... }
  Future<void> loadAllArtworks() async { ... }
  Future<Artwork?> getArtworkById(String id) async { ... }
}
```

**Limitaciones del Provider Actual:**

- Solo maneja datos de obras de arte
- No maneja obras guardadas
- No maneja estado de usuario
- No maneja estado de tickets
- Manejo de errores básico

## ✨ Características Principales

### 🏠 Pantalla Principal (HomeScreen)

- **Estado**: ✅ Completamente funcional con Provider
- **Características**:
  - Secciones "Popular" y "What's New"
  - Categorías de navegación
  - Búsqueda (UI implementada, funcionalidad pendiente)
  - Navegación a detalle de obras

### 🎨 Lista de Obras (ArtworksScreen)

- **Estado**: ✅ Funcional con Provider
- **Características**:
  - Grid de todas las obras
  - Navegación a detalle
  - Loading states

### 📖 Detalle de Obra (ArtworkDetailScreen)

- **Estado**: ✅ Funcional con limitaciones
- **Características**:
  - Visualización de obra completa
  - Descripción expandible/colapsable
  - Audioguía integrada
  - Funcionalidad de guardar/desguardar
  - Obras relacionadas
  - **Problema**: No actualiza automáticamente SavedScreen

### 💾 Obras Guardadas (SavedScreen)

- **Estado**: ⚠️ Funcional pero problemática
- **Características**:
  - Lista de obras guardadas
  - Persistencia en SQLite
  - **Problemas**:
    - No usa Provider
    - Requiere recreación manual para actualizarse
    - No se actualiza automáticamente

### 👤 Perfil (ProfileScreen)

- **Estado**: ✅ UI completa, datos estáticos
- **Características**:
  - Información de usuario
  - Estadísticas (hardcoded)
  - Configuraciones
  - **Problema**: Datos no dinámicos

### 🎫 Tickets (TicketsScreen)

- **Estado**: ❌ Solo placeholder
- **Características**: Ninguna implementada

### 🔍 Escaneo QR

- **Estado**: ✅ Botón implementado
- **Características**: Funcionalidad de escaneo básica

## ⚙️ Configuración e Instalación

### Prerrequisitos:

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Dispositivo físico o emulador

### Instalación:

1. **Clonar el repositorio:**

   ```bash
   git clone <repository-url>
   cd culture_connect
   ```

2. **Instalar dependencias:**

   ```bash
   flutter pub get
   ```

3. **Generar archivos de localización:**

   ```bash
   flutter gen-l10n
   ```

4. **Ejecutar la aplicación:**
   ```bash
   flutter run
   ```

### Configuración de Assets:

Los assets están configurados en `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/
    - assets/audio/
  fonts:
    - family: Playfair
      fonts:
        - asset: assets/fonts/PlayfairDisplay-Medium.ttf
          weight: 500
        - asset: assets/fonts/PlayfairDisplay-Bold.ttf
          weight: 700
    - family: Urbanist
      fonts:
        - asset: assets/fonts/Urbanist-Thin.ttf
          weight: 100
        # ... más pesos de fuente
```

## 🚀 Mejoras Recomendadas

### 1. **Reestructuración Completa del Manejo de Estado**

#### Crear Providers Especializados:

```dart
// providers/saved_artworks_provider.dart
class SavedArtworksProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<SavedArtwork> _savedArtworks = [];
  bool _isLoading = false;

  List<SavedArtwork> get savedArtworks => _savedArtworks;
  bool get isLoading => _isLoading;

  Future<void> loadSavedArtworks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _savedArtworks = await _databaseService.getAllSavedArtworks();
    } catch (e) {
      // Manejar error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveArtwork(Artwork artwork) async {
    final savedArtwork = SavedArtwork(
      title: artwork.title,
      imageUrl: artwork.imageUrl,
      description: artwork.description ?? '',
      savedAt: DateTime.now(),
    );

    await _databaseService.saveArtwork(savedArtwork);
    await loadSavedArtworks(); // Recargar lista
  }

  Future<void> removeSavedArtwork(String title) async {
    await _databaseService.deleteArtwork(title);
    await loadSavedArtworks(); // Recargar lista
  }

  bool isArtworkSaved(String title) {
    return _savedArtworks.any((artwork) => artwork.title == title);
  }
}
```

#### Configuración en main.dart:

```dart
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
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TicketsProvider(),
        ),
      ],
      child: const MuseumApp(),
    ),
  );
}
```

### 2. **Refactorizar SavedScreen para usar Provider**

```dart
class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar obras guardadas al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedArtworksProvider>().loadSavedArtworks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Artworks'),
      ),
      body: Consumer<SavedArtworksProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.savedArtworks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No saved artworks yet'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.savedArtworks.length,
            itemBuilder: (context, index) {
              final artwork = provider.savedArtworks[index];
              return SavedArtworkCard(
                artwork: artwork,
                onRemove: () async {
                  await provider.removeSavedArtwork(artwork.title);
                },
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.artworkDetail,
                    arguments: {
                      'id': artwork.title, // Usar title como ID temporal
                      'title': artwork.title,
                      'imageUrl': artwork.imageUrl,
                      'description': artwork.description,
                      'relatedArtworks': const [],
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
```

### 3. **Mejorar ArtworkDetailScreen para sincronización**

```dart
class _ArtworkDetailScreenState extends State<ArtworkDetailScreen> {
  // ... código existente

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedArtworksProvider>(
      builder: (context, savedProvider, child) {
        final isSaved = savedProvider.isArtworkSaved(widget.title);

        return Scaffold(
          // ... resto del código
          body: Stack(
            children: [
              // ... contenido existente
              Positioned(
                top: MediaQuery.of(context).padding.top,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (isSaved) {
                        await savedProvider.removeSavedArtwork(widget.title);
                      } else {
                        // Crear Artwork desde los datos disponibles
                        final artwork = Artwork(
                          id: widget.id,
                          title: widget.title,
                          artist: 'Unknown', // Necesitarás pasar este dato
                          imageUrl: widget.imageUrl,
                          type: 'Unknown',
                          description: widget.description,
                        );
                        await savedProvider.saveArtwork(artwork);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

## ⚠️ Problemas Identificados

### 1. **Problemas Críticos:**

- **SavedScreen no usa Provider**: Causa inconsistencias en el estado
- **Falta de sincronización**: Cambios en ArtworkDetailScreen no se reflejan en SavedScreen
- **TicketsScreen vacía**: Funcionalidad principal sin implementar
- **Datos hardcoded**: Estadísticas y datos de usuario no dinámicos

### 2. **Problemas de Arquitectura:**

- **Inconsistencia en patrones**: Mezcla de FutureBuilder con Provider
- **Servicios acoplados**: DatabaseService usado directamente en widgets
- **Falta de abstracción**: No hay interfaces/contratos para servicios
- **Manejo de errores básico**: Sin estrategia unificada para errores

### 3. **Problemas de UI/UX:**

- **Búsqueda no funcional**: Solo UI implementada
- **Navegación inconsistente**: Algunas acciones no funcionan
- **Estados de carga**: No todos los estados están manejados
- **Accesibilidad**: Falta de etiquetas semánticas

### 4. **Problemas de Performance:**

- **Recreación innecesaria**: SavedScreen se recrea manualmente
- **Caché limitado**: Solo para imágenes, no para datos
- **Consultas frecuentes**: Base de datos consultada en cada rebuild

## 🗺️ Roadmap de Mejoras

### Fase 1: Estabilización (1-2 semanas)

- [ ] Implementar SavedArtworksProvider
- [ ] Refactorizar SavedScreen para usar Provider
- [ ] Sincronizar estado entre ArtworkDetailScreen y SavedScreen
- [ ] Implementar manejo básico de errores

### Fase 2: Funcionalidades Principales (2-3 semanas)

- [ ] Implementar TicketsScreen completa
- [ ] Implementar funcionalidad de búsqueda
- [ ] Crear UserProvider para datos dinámicos
- [ ] Mejorar navegación y deep linking

### Fase 3: Arquitectura Avanzada (3-4 semanas)

- [ ] Implementar Repository Pattern
- [ ] Añadir testing unitario y de widgets
- [ ] Implementar caché inteligente
- [ ] Optimizar performance

### Fase 4: Características Avanzadas (4-6 semanas)

- [ ] Implementar autenticación
- [ ] Añadir notificaciones push
- [ ] Mejorar accesibilidad
- [ ] Implementar analytics
- [ ] Añadir modo offline

### Fase 5: Pulimiento (1-2 semanas)

- [ ] Optimización final
- [ ] Testing de integración
- [ ] Documentación completa
- [ ] Preparación para producción

## 📝 Conclusiones y Recomendaciones

**Culture Connect** es una aplicación con una base sólida y un diseño atractivo, pero que requiere mejoras significativas en el manejo de estado y la arquitectura para ser verdaderamente robusta y escalable.

### Fortalezas Actuales:

- ✅ UI/UX bien diseñada y moderna
- ✅ Estructura de proyecto organizada
- ✅ Uso correcto de Provider en algunas pantallas
- ✅ Internacionalización implementada
- ✅ Funcionalidades básicas funcionando

### Áreas Críticas de Mejora:

- ❌ Inconsistencia en manejo de estado
- ❌ Falta de sincronización entre pantallas
- ❌ Funcionalidades incompletas (Tickets, Búsqueda)
- ❌ Manejo de errores básico
- ❌ Testing inexistente

### Recomendación Principal:

**Priorizar la refactorización del manejo de estado** antes de añadir nuevas funcionalidades. Una vez que se tenga un sistema de estado consistente con Provider, el desarrollo de nuevas características será mucho más eficiente y mantenible.

### Decisión sobre Estructura de Documentación:

He optado por **UN README principal detallado** en lugar de múltiples READMEs porque:

1. **Facilita el mantenimiento**: Un solo archivo es más fácil de mantener actualizado
2. **Mejor experiencia de usuario**: Los desarrolladores pueden encontrar toda la información en un lugar
3. **Tamaño apropiado**: La aplicación es de tamaño mediano, no requiere documentación fragmentada
4. **Navegación eficiente**: La tabla de contenidos permite navegar rápidamente a secciones específicas

### Próximos Pasos Inmediatos:

1. **Implementar SavedArtworksProvider** (Prioridad Alta)
2. **Refactorizar SavedScreen** (Prioridad Alta)
3. **Sincronizar ArtworkDetailScreen** (Prioridad Alta)
4. **Implementar TicketsScreen** (Prioridad Media)
5. **Añadir funcionalidad de búsqueda** (Prioridad Media)

La aplicación tiene un gran potencial y con las mejoras sugeridas puede convertirse en una experiencia de usuario excepcional para visitantes de museos.

---

_Última actualización: Septiembre 2025_  
_Versión del documento: 1.0_
