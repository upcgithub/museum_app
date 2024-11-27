import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:museum_app/core/services/database_service.dart';
import 'package:museum_app/core/models/saved_artwork.dart';
import 'package:audioplayers/audioplayers.dart';

class ArtworkDetailScreen extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  final bool isViewed;
  final String description;
  final List<Map<String, dynamic>> relatedArtworks;

  const ArtworkDetailScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
    this.isViewed = false,
    required this.description,
    required this.relatedArtworks,
  }) : super(key: key);

  @override
  _ArtworkDetailScreenState createState() => _ArtworkDetailScreenState();
}

class _ArtworkDetailScreenState extends State<ArtworkDetailScreen> {
  bool _isSaved = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
    _setupAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  Future<void> _togglePlay() async {
    final audioUrl =
        'audio/${widget.id.replaceAll(' ', '_').toLowerCase()}.mp3';

    log('Audio URL: $audioUrl');

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(audioUrl));
    }
  }

  Future<void> _checkIfSaved() async {
    final isSaved = await DatabaseService.instance.isArtworkSaved(widget.title);
    setState(() {
      _isSaved = isSaved;
    });
  }

  Future<void> _toggleSave() async {
    if (_isSaved) {
      await DatabaseService.instance.deleteArtwork(widget.title);
    } else {
      final artwork = SavedArtwork(
        title: widget.title,
        imageUrl: widget.imageUrl,
        description: widget.description,
        savedAt: DateTime.now(),
      );
      await DatabaseService.instance.saveArtwork(artwork);
    }
    setState(() {
      _isSaved = !_isSaved;
    });
  }

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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFA69365),
                            ),
                            child: IconButton(
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _togglePlay,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      /*TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.saved);
                          },
                          child: const Text(
                            'go to saved',
                            style: TextStyle(
                              fontFamily: 'Playfair',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          )),*/
                      const SizedBox(height: 8),
                      Text(
                        widget.description,
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
                          itemCount: widget.relatedArtworks.length,
                          itemBuilder: (context, index) {
                            final artwork = widget.relatedArtworks[index];
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
                      icon: Icon(
                        _isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                      ),
                      onPressed: _toggleSave,
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
