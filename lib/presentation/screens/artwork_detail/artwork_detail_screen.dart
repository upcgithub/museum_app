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
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      /*const Text(
                        'Description',
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),*/
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
                          child: const Text(
                            'Read more',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFA69365),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Related to this artwork',
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFA69365),
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      artwork['imageUrl'],
                                      width: 150,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
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
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
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
            ),
          ),
          if (isViewed)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5 - 40,
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
    );
  }
}
