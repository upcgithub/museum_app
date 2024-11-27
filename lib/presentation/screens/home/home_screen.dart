import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:museum_app/presentation/providers/museum_provider.dart';
import 'package:museum_app/presentation/widgets/artwork_card.dart';
import 'package:museum_app/presentation/navigation/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<MuseumProvider>();
      provider.loadPopularArtworks();
      provider.loadWhatsNewArtworks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategories(),
            _buildPopularSection(),
            _buildWhatsNewSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset('assets/logo.png', height: 40),
            const Spacer(),
            const Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    Text(
                      'Location',
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Lima, Peru',
                  style: TextStyle(
                    fontFamily: 'Playfair',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.confirmation_number_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search exhibitions, events...',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'icon': Icons.museum_outlined, 'label': 'Exhibition'},
      {'icon': Icons.event_outlined, 'label': 'Events'},
      {'icon': Icons.palette_outlined, 'label': 'Artwork'},
      {'icon': Icons.person_outline, 'label': 'Artist'},
    ];

    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: categories
            .map((category) => GestureDetector(
                  onTap: () {
                    if (category['label'] == 'Artwork') {
                      Navigator.pushNamed(context, AppRoutes.artworks);
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.black,
                        child: Icon(
                          category['icon'] as IconData,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['label'] as String,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildPopularSection() {
    return Consumer<MuseumProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Popular",
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implementar navegación a la vista completa
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: provider.popularArtworks.length,
                itemBuilder: (context, index) {
                  final artwork = provider.popularArtworks[index];
                  // return ArtworkCard(artwork: artwork);
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.artworkDetail,
                        arguments: {
                          'id': artwork.id,
                          'title': artwork.title,
                          'imageUrl': artwork.imageUrl,
                          'description': artwork.description ?? '',
                          'relatedArtworks': const [
                            {
                              'imageUrl':
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Fabritius-vink.jpg/490px-Fabritius-vink.jpg',
                              'title': 'Vink',
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
                    child: ArtworkCard(artwork: artwork),
                  );
                },
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget _buildWhatsNewSection() {
    return Consumer<MuseumProvider>(
      builder: (context, provider, child) {
        return SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
                top: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "What's new",
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implementar navegación a la vista completa
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: provider.whatsNewArtworks.length,
                itemBuilder: (context, index) {
                  final artwork = provider.whatsNewArtworks[index];
                  // return ArtworkCard(artwork: artwork);
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.artworkDetail,
                        arguments: {
                          'id': artwork.id,
                          'title': artwork.title,
                          'imageUrl': artwork.imageUrl,
                          'description': artwork.description ?? '',
                          'relatedArtworks': const [
                            {
                              'imageUrl':
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Fabritius-vink.jpg/490px-Fabritius-vink.jpg',
                              'title': 'Vink',
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
                    child: ArtworkCard(artwork: artwork),
                  );
                },
              ),
            ),
          ]),
        );
      },
    );
  }
}
