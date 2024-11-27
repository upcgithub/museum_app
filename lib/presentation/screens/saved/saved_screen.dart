import 'package:flutter/material.dart';
import 'package:museum_app/core/services/database_service.dart';
import 'package:museum_app/core/models/saved_artwork.dart';
import 'package:museum_app/presentation/navigation/routes.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({Key? key}) : super(key: key);

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
      ),
      body: FutureBuilder<List<SavedArtwork>>(
        future: DatabaseService.instance.getAllSavedArtworks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No saved artworks yet'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final artwork = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.artworkDetail,
                    arguments: {
                      'id': artwork.id,
                      'title': artwork.title,
                      'imageUrl': artwork.imageUrl,
                      'description': artwork.description,
                      'relatedArtworks': const [],
                    },
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8),
                        ),
                        child: Image.network(
                          artwork.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
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
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Saved on ${artwork.savedAt.day}/${artwork.savedAt.month}/${artwork.savedAt.year}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
