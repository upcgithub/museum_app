import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:museum_app/presentation/providers/saved_artworks_provider.dart';
import 'package:museum_app/domain/entities/artwork.dart';
import 'package:museum_app/core/theme/app_colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:museum_app/presentation/widgets/ai_options_bottom_sheet.dart';
import 'package:museum_app/presentation/screens/artist_chat/artist_chat_screen.dart';
import 'package:museum_app/presentation/screens/style_transfer/style_transfer_screen.dart';

class ArtworkDetailScreen extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  final bool isViewed;
  final String description;
  final List<Map<String, dynamic>> relatedArtworks;
  final String? artist;

  const ArtworkDetailScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
    this.isViewed = false,
    required this.description,
    required this.relatedArtworks,
    this.artist,
  }) : super(key: key);

  @override
  _ArtworkDetailScreenState createState() => _ArtworkDetailScreenState();
}

class _ArtworkDetailScreenState extends State<ArtworkDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isExpanded = false;

  // StreamSubscriptions para poder cancelarlas en dispose()
  late StreamSubscription _playerStateSubscription;
  late StreamSubscription _playerCompleteSubscription;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
    // Cargar obras guardadas si no están cargadas aún
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SavedArtworksProvider>();
      if (provider.savedArtworks.isEmpty && !provider.isLoading) {
        provider.loadSavedArtworks();
      }
    });
  }

  @override
  void dispose() {
    // Cancelar las suscripciones antes de dispose
    _playerStateSubscription.cancel();
    _playerCompleteSubscription.cancel();

    // Detener y dispose del audio player
    _audioPlayer.stop();
    _audioPlayer.dispose();

    super.dispose();
  }

  void _setupAudioPlayer() {
    // Guardar las suscripciones para poder cancelarlas después
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        // Verificar que el widget aún está montado
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        // Verificar que el widget aún está montado
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _togglePlay() async {
    if (!mounted) return; // Verificar que el widget esté montado

    final audioUrl =
        'audio/${widget.id.replaceAll(' ', '_').toLowerCase()}.mp3';

    log('Audio URL: $audioUrl');

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(AssetSource(audioUrl));
      }
    } catch (e) {
      log('Error playing audio: $e');
      // Si hay error, asegurar que el estado se actualice
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  void _showAiOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AiOptionsBottomSheet(
        artist: widget.artist ?? 'Unknown Artist',
        onPlayAudio: _togglePlay,
        onChatWithArtist: _openArtistChat,
        onStylizePhoto: _openStyleTransfer,
      ),
    );
  }

  void _openArtistChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArtistChatScreen(
          artist: widget.artist ?? 'Unknown Artist',
          artworkTitle: widget.title,
          artworkImageUrl: widget.imageUrl,
          description: widget.description,
        ),
      ),
    );
  }

  void _openStyleTransfer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StyleTransferScreen(
          artist: widget.artist ?? 'Unknown Artist',
          artworkTitle: widget.title,
          artworkImageUrl: widget.imageUrl,
        ),
      ),
    );
  }

  Future<void> _toggleSave(SavedArtworksProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final artwork = Artwork(
      id: widget.id,
      title: widget.title,
      artist: widget.artist ?? 'Unknown',
      imageUrl: widget.imageUrl,
      type: 'Unknown',
      description: widget.description,
    );

    await provider.toggleSaveArtwork(artwork);

    // Mostrar feedback al usuario
    if (mounted) {
      final isNowSaved = provider.isArtworkSaved(widget.title);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isNowSaved
                ? l10n.artworkSavedToCollection(widget.title)
                : l10n.artworkRemovedFromSaved(widget.title),
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: isNowSaved ? AppColors.success : AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<SavedArtworksProvider>(
      builder: (context, savedProvider, child) {
        final isSaved = savedProvider.isArtworkSaved(widget.title);

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
                          widget.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    style: const TextStyle(
                                      fontFamily: 'Playfair',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFA69365),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.auto_awesome,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: _showAiOptions,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            AnimatedCrossFade(
                              firstChild: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.description,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              secondChild: Text(
                                widget.description,
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              crossFadeState: _isExpanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 300),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Text(
                                  _isExpanded ? l10n.readLess : l10n.readMore,
                                  style: const TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFA69365),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.relatedToThisArtwork,
                              style: const TextStyle(
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
                                itemCount: widget.relatedArtworks.length,
                                itemBuilder: (context, index) {
                                  final artwork = widget.relatedArtworks[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            artwork['imageUrl'],
                                            width: 150,
                                            height: 200,
                                            fit: BoxFit.cover,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                            icon: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: Colors.white,
                            ),
                            onPressed: () => _toggleSave(savedProvider),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.isViewed)
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
                      child: Text(
                        l10n.viewed,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ));
      },
    );
  }
}
