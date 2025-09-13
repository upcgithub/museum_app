import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:museum_app/presentation/providers/saved_artworks_provider.dart';
import 'package:museum_app/presentation/navigation/routes.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar obras guardadas SOLO la primera vez
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SavedArtworksProvider>();
      if (provider.savedArtworks.isEmpty && !provider.isLoading) {
        provider.loadSavedArtworks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Artworks',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // Botón para refrescar manualmente si es necesario
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SavedArtworksProvider>().loadSavedArtworks();
            },
          ),
        ],
      ),
      body: Consumer<SavedArtworksProvider>(
        builder: (context, provider, child) {
          // Estado de carga
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFFA69365),
                  ),
                  SizedBox(height: 16),
                  Text('Loading saved artworks...'),
                ],
              ),
            );
          }

          // Estado de error
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadSavedArtworks(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Lista vacía
          if (provider.savedArtworks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No saved artworks yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Playfair',
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start exploring and save your favorite artworks!',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Lista de obras guardadas
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.savedArtworks.length,
            itemBuilder: (context, index) {
              final artwork = provider.savedArtworks[index];
              return Dismissible(
                key: Key(artwork.title),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: Colors.red[400],
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Remove',
                        style: TextStyle(
                          color: Colors.red[400],
                          fontSize: 12,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                confirmDismiss: (direction) async {
                  // Mostrar confirmación antes de eliminar
                  return await _showRemoveDialog(context, artwork.title);
                },
                onDismissed: (direction) async {
                  await provider.removeSavedArtwork(artwork.title);

                  // Mostrar snackbar de confirmación
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${artwork.title} removed from saved'),
                        backgroundColor: Colors.red[400],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        action: SnackBarAction(
                          label: 'Undo',
                          textColor: Colors.white,
                          onPressed: () {
                            // TODO: Implementar undo functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Undo functionality coming soon!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
                child: SavedArtworkCard(
                  artwork: artwork,
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
                  onBookmarkToggle: () async {
                    // Confirmar eliminación via bookmark
                    final shouldRemove =
                        await _showRemoveDialog(context, artwork.title);
                    if (shouldRemove == true) {
                      await provider.removeSavedArtwork(artwork.title);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${artwork.title} removed from saved'),
                            backgroundColor: Colors.orange[400],
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool?> _showRemoveDialog(BuildContext context, String artworkTitle) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.bookmark_remove,
              color: Colors.orange[400],
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Remove from Saved',
              style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontFamily: 'Urbanist',
            ),
            children: [
              const TextSpan(text: 'Are you sure you want to remove '),
              TextSpan(
                text: '"$artworkTitle"',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Playfair',
                ),
              ),
              const TextSpan(text: ' from your saved artworks?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Remove',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SavedArtworkCard extends StatelessWidget {
  final dynamic artwork; // SavedArtwork
  final VoidCallback onTap;
  final VoidCallback onBookmarkToggle;

  const SavedArtworkCard({
    Key? key,
    required this.artwork,
    required this.onTap,
    required this.onBookmarkToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      //elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Imagen
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(8),
              ),
              child: Image.network(
                artwork.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artwork.title,
                      style: const TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Saved on ${artwork.savedAt.day}/${artwork.savedAt.month}/${artwork.savedAt.year}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bookmark toggle (más sutil y elegante)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: onBookmarkToggle,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.bookmark,
                      color: const Color(0xFFA69365),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
