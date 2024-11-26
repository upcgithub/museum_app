import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:museum_app/domain/entities/artwork.dart';

class ArtworkCard extends StatelessWidget {
  final Artwork artwork;

  const ArtworkCard({super.key, required this.artwork});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: artwork.imageUrl,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            artwork.title,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Playfair',
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            artwork.artist,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
