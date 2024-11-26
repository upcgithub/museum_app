import 'package:flutter/material.dart';

class ArtworkDetailScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isViewed;
  final String description;
  final List<Map<String, dynamic>> relatedArtworks;

  const ArtworkDetailScreen({
    Key? key,
    required this.title,
    required this.imageUrl,
    this.isViewed = false,
    required this.description,
    required this.relatedArtworks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontFamily: 'Playfair',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Implementar lógica de bookmark
                    },
                  ),
                ),
                if (isViewed)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Viewed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Implementar lógica para mostrar más
                      },
                      child: const Text('Read more'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Related to this artwork',
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: relatedArtworks.length,
                      itemBuilder: (context, index) {
                        final artwork = relatedArtworks[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Stack(
                            children: [
                              Image.network(
                                artwork['imageUrl'],
                                width: 150,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.bookmark_border,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // Implementar lógica de bookmark
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
