import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:museum_app/presentation/providers/museum_provider.dart';
import 'package:museum_app/presentation/widgets/artwork_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<MuseumProvider>().loadPopularArtworks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const SizedBox(width: 12),
            const Text('Den Haag, Netherlands'),
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
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search exhibitions, events...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'icon': Icons.museum, 'label': 'Exhibition'},
      {'icon': Icons.event, 'label': 'Events'},
      {'icon': Icons.palette, 'label': 'Artwork'},
      {'icon': Icons.person, 'label': 'Artist'},
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(category['icon'] as IconData),
                  ),
                  const SizedBox(height: 8),
                  Text(category['label'] as String),
                ],
              ),
            );
          },
        ),
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Popular',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
                  return ArtworkCard(artwork: artwork);
                },
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget _buildWhatsNewSection() {
    // Similar to Popular section but with different data
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
