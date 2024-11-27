# Museo App

Una aplicación móvil moderna para museos desarrollada con Flutter que permite a los usuarios explorar obras de arte, comprar tickets y guardar sus piezas favoritas.

## 🎨 Características

- Exploración de obras de arte con búsqueda y filtros
- Compra de tickets para el museo
- Sistema de favoritos para guardar obras
- Perfil de usuario personalizado
- Soporte multiidioma (Español e Inglés)
- Modo oscuro/claro
- Diseño adaptable para diferentes tamaños de pantalla

## 🛠️ Tecnologías

- Flutter 3.19.0
- Dart 3.3.0
- Firebase (Authentication, Firestore, Storage)
- GetX para gestión de estado
- Clean Architecture

## 📚 Librerías Principales

- `get: ^4.6.6` - Gestión de estado y navegación
- `firebase_core: ^2.24.2` - Configuración base de Firebase
- `firebase_auth: ^4.15.3` - Autenticación de usuarios
- `cloud_firestore: ^4.13.6` - Base de datos NoSQL
- `firebase_storage: ^11.5.6` - Almacenamiento de imágenes
- `cached_network_image: ^3.3.0` - Caché de imágenes
- `flutter_svg: ^2.0.9` - Renderizado de SVGs
- `intl: ^0.18.1` - Internacionalización
- `shared_preferences: ^2.2.2` - Almacenamiento local
- `dio: ^5.4.0` - Cliente HTTP
- `flutter_dotenv: ^5.1.0` - Variables de entorno

## 🏗️ Arquitectura

El proyecto sigue los principios de Clean Architecture con la siguiente estructura:

```
lib/
  ├── core/              # Utilidades y configuraciones core
  ├── data/              # Capa de datos
  │   ├── models/        # Modelos de datos
  │   ├── repositories/  # Implementación de repositorios
  │   └── services/      # Servicios externos
  ├── domain/            # Lógica de negocio
  │   ├── entities/      # Entidades del dominio
  │   ├── repositories/  # Interfaces de repositorios
  │   └── usecases/      # Casos de uso
  ├── presentation/      # Capa de presentación
  │   ├── screens/       # Pantallas
  │   ├── widgets/       # Widgets reutilizables
  │   └── controllers/   # Controladores
  └── l10n/              # Archivos de internacionalización
```

## 🚀 Instalación

1. Clona el repositorio:

```bash
git clone https://github.com/usuario/museo-app.git
```

2. Instala las dependencias:

```bash
flutter pub get
```

3. Configura las variables de entorno:

   - Crea un archivo `.env` en la raíz del proyecto
   - Añade las variables necesarias siguiendo el ejemplo en `.env.example`

4. Ejecuta la aplicación:

```bash
flutter run
```

## 📱 Capturas de Pantalla

### Pantalla de Inicio

![Home Screen](screenshots/home_screen.png)

### Exploración de Obras

![Artworks Screen](screenshots/artworks_screen.png)

### Detalle de Obra

![Artwork Detail](screenshots/artwork_detail.png)

## 🌐 Soporte de Idiomas

La aplicación está disponible en:

- Español (es)
- Inglés (en)

Para añadir un nuevo idioma:

1. Crea un nuevo archivo en la carpeta `lib/l10n/`
2. Sigue el formato de los archivos existentes (`app_en.arb`, `app_es.arb`)
3. Actualiza el archivo `l10n.yaml` si es necesario

## 🔒 Seguridad

- Autenticación segura mediante Firebase Auth
- Almacenamiento seguro de datos sensibles
- Validación de datos en el cliente y servidor
- Cifrado de información sensible

## 🤝 Contribución

Las contribuciones son bienvenidas. Por favor:

1. Haz Fork del proyecto
2. Crea una rama para tu característica (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE.md](LICENSE.md) para más detalles.

## 👥 Autores

- Hans Leonel Jurado Muñoz - _Trabajo Inicial_ - [@hansleonel](https://github.com/hansleonel)

## 🙏 Agradecimientos

- Equipo de Flutter por el excelente framework
- Firebase por la infraestructura backend
- Contribuidores y beta testers

## 📞 Contacto

Para preguntas y soporte:

- Email: soporte@museo-app.com
- Twitter: [@codehans](https://twitter.com/codehans)

## 📝 Notas de la Versión

### Versión 1.0.0 (Actual)

- Lanzamiento inicial
- Funcionalidades básicas implementadas
- Soporte para iOS y Android

### Próximas Características

- [ ] Integración con realidad aumentada
- [ ] Tours virtuales
- [ ] Sistema de notificaciones
- [ ] Más idiomas
