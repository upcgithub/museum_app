import 'package:flutter/material.dart';
import 'package:museum_app/presentation/navigation/routes.dart';
import 'package:provider/provider.dart';
import 'package:museum_app/domain/entities/artwork.dart';
import 'package:museum_app/presentation/providers/museum_provider.dart';

class ArtworksScreen extends StatefulWidget {
  const ArtworksScreen({super.key});

  @override
  State<ArtworksScreen> createState() => _ArtworksScreenState();
}

class _ArtworksScreenState extends State<ArtworksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MuseumProvider>().loadAllArtworks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Artworks',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<MuseumProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFA69365),
              ),
            );
          }

          if (provider.allArtworks.isEmpty) {
            return const Center(
              child: Text(
                'No artworks found',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 16,
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: provider.allArtworks.length,
            itemBuilder: (context, index) {
              final artwork = provider.allArtworks[index];
              return _ArtworkGridItem(artwork: artwork);
            },
          );
        },
      ),
    );
  }
}

class _ArtworkGridItem extends StatelessWidget {
  final Artwork artwork;

  const _ArtworkGridItem({required this.artwork});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.artworkDetail,
          arguments: {
            'title': artwork.title,
            'imageUrl': artwork.imageUrl,
            'description': artwork.description ?? '',
            'relatedArtworks': [
              {
                'imageUrl':
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Fabritius-vink.jpg/490px-Fabritius-vink.jpg',
                'title': 'Chaffinch',
              },
              {
                'imageUrl':
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/Vermeer%2C_Johannes_-_Woman_reading_a_letter_-_ca._1662-1663.jpg/1920px-Vermeer%2C_Johannes_-_Woman_reading_a_letter_-_ca._1662-1663.jpg',
                'title': 'The Milkmaid',
              },
            ],
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                artwork.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            artwork.title,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Playfair',
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            artwork.artist,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
