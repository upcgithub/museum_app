import 'package:flutter/material.dart';
import 'package:museum_app/core/theme/app_colors.dart';
import 'package:museum_app/l10n/app_localizations.dart';

class AiOptionsBottomSheet extends StatelessWidget {
  final String artist;
  final VoidCallback onPlayAudio;
  final VoidCallback onChatWithArtist;
  final VoidCallback onStylizePhoto;

  const AiOptionsBottomSheet({
    Key? key,
    required this.artist,
    required this.onPlayAudio,
    required this.onChatWithArtist,
    required this.onStylizePhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.aiFeaturesTitle,
                style: const TextStyle(
                  fontFamily: 'Playfair',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
                color: AppColors.secondary,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Option cards
          _AiOptionCard(
            icon: Icons.headphones,
            title: l10n.playAudioGuide,
            description: l10n.playAudioGuideDesc,
            onTap: () {
              Navigator.of(context).pop();
              onPlayAudio();
            },
          ),
          const SizedBox(height: 12),
          _AiOptionCard(
            icon: Icons.chat_bubble_outline,
            title: l10n.chatWithArtist(artist),
            description: l10n.chatWithArtistDesc,
            onTap: () {
              Navigator.of(context).pop();
              onChatWithArtist();
            },
          ),
          const SizedBox(height: 12),
          _AiOptionCard(
            icon: Icons.auto_fix_high,
            title: l10n.stylizeYourPhoto,
            description: l10n.stylizeYourPhotoDesc(artist),
            onTap: () {
              Navigator.of(context).pop();
              onStylizePhoto();
            },
          ),
        ],
      ),
    );
  }
}

class _AiOptionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _AiOptionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_AiOptionCard> createState() => _AiOptionCardState();
}

class _AiOptionCardState extends State<_AiOptionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isPressed
                ? AppColors.primary
                : Colors.grey.withValues(alpha: 0.2),
            width: _isPressed ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isPressed
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: _isPressed ? 12 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
