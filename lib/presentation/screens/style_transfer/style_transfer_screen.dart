import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:museum_app/core/theme/app_colors.dart';
import 'package:museum_app/l10n/app_localizations.dart';
import 'package:museum_app/presentation/providers/gemini_provider.dart';

class StyleTransferScreen extends StatefulWidget {
  final String artist;
  final String artworkTitle;
  final String artworkImageUrl;

  const StyleTransferScreen({
    Key? key,
    required this.artist,
    required this.artworkTitle,
    required this.artworkImageUrl,
  }) : super(key: key);

  @override
  State<StyleTransferScreen> createState() => _StyleTransferScreenState();
}

class _StyleTransferScreenState extends State<StyleTransferScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    log('🎨 StyleTransferScreen: initState called');
    log('   Artist: ${widget.artist}');
    log('   Artwork: ${widget.artworkTitle}');

    // Clear any previous style transfer state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('🧹 StyleTransferScreen: Clearing previous state...');
      context.read<GeminiProvider>().clearStyleTransfer();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    log('📷 StyleTransferScreen: _pickImage called');
    log('   Source: $source');

    try {
      log('🖼️ StyleTransferScreen: Opening image picker...');
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        log('✅ StyleTransferScreen: Image selected');
        log('   Path: ${image.path}');
        log('   Name: ${image.name}');

        if (mounted) {
          log('🚀 StyleTransferScreen: Starting style transfer via provider...');
          final provider = context.read<GeminiProvider>();
          await provider.startStyleTransfer(
            image: File(image.path),
            artistStyle: widget.artist,
            artworkTitle: widget.artworkTitle,
          );
          log('✅ StyleTransferScreen: Style transfer completed');
        } else {
          log('⚠️ StyleTransferScreen: Widget not mounted, skipping transfer');
        }
      } else {
        log('⚠️ StyleTransferScreen: No image selected');
      }
    } catch (e) {
      log('❌ StyleTransferScreen: Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to pick image: $e',
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _shareImage(Uint8List imageBytes, AppLocalizations l10n) async {
    log('📤 StyleTransferScreen: _shareImage called');
    try {
      // Create a temporary file to share
      final tempDir = await getTemporaryDirectory();
      final fileName =
          'stylized_${widget.artist.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${tempDir.path}/$fileName');

      log('💾 StyleTransferScreen: Writing image to temp file...');
      await file.writeAsBytes(imageBytes);
      log('✅ StyleTransferScreen: Temp file created: ${file.path}');

      // Share the file
      log('📤 StyleTransferScreen: Sharing file...');
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '${l10n.stylizedImage} - ${widget.artist} style',
      );
      log('✅ StyleTransferScreen: Share completed');
    } catch (e) {
      log('❌ StyleTransferScreen: Error sharing image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.shareError,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _saveImage(Uint8List imageBytes, AppLocalizations l10n) async {
    log('💾 StyleTransferScreen: _saveImage called');
    try {
      // Save to gallery using image_picker's XFile
      final tempDir = await getTemporaryDirectory();
      final fileName =
          'stylized_${widget.artist.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${tempDir.path}/$fileName');

      log('💾 StyleTransferScreen: Writing image to file...');
      await file.writeAsBytes(imageBytes);
      log('✅ StyleTransferScreen: File saved: ${file.path}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.imageSaved,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: l10n.share,
              textColor: Colors.white,
              backgroundColor: Colors.white.withOpacity(0.2),
              onPressed: () => _shareImage(imageBytes, l10n),
            ),
          ),
        );
      }
    } catch (e) {
      log('❌ StyleTransferScreen: Error saving image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.saveError,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showImageSourceDialog(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.selectPhoto,
                style: const TextStyle(
                  fontFamily: 'Playfair',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: AppColors.primary),
                title: Text(
                  l10n.gallery,
                  style: const TextStyle(fontFamily: 'Urbanist'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text(
                  l10n.camera,
                  style: const TextStyle(fontFamily: 'Urbanist'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.stylizeYourPhoto,
              style: const TextStyle(
                fontFamily: 'Playfair',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
            Text(
              l10n.artistStyle(widget.artist),
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          // Botón discreto para intentar con otra imagen
          Consumer<GeminiProvider>(
            builder: (context, provider, child) {
              // Solo mostrar si ya hay una imagen cargada
              if (provider.originalImage != null) {
                return IconButton(
                  icon: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: AppColors.primary,
                  ),
                  tooltip: l10n.tryAnother,
                  onPressed: () => _showImageSourceDialog(context, l10n),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<GeminiProvider>(
        builder: (context, provider, child) {
          if (provider.originalImage == null) {
            return _buildEmptyState(l10n);
          }

          if (provider.isStyleTransferLoading) {
            return _buildLoadingState(l10n);
          }

          if (provider.styleTransferError != null) {
            return _buildErrorState(l10n, provider.styleTransferError!);
          }

          // Show the stylized image if available, otherwise show the prompt
          if (provider.stylizedImageBytes != null ||
              provider.styleTransferPrompt != null) {
            return _buildResultState(l10n, provider);
          }

          return _buildEmptyState(l10n);
        },
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Artwork preview
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.artworkImageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 48),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            const Icon(
              Icons.auto_fix_high,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.stylizeYourPhoto,
              style: const TextStyle(
                fontFamily: 'Playfair',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.stylizeYourPhotoDesc(widget.artist),
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showImageSourceDialog(context, l10n),
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(l10n.selectPhoto),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.applyingStyle(widget.artist),
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.thisMayTakeAMoment,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.styleTransferError,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _showImageSourceDialog(context, l10n),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultState(AppLocalizations l10n, GeminiProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original Image
          Text(
            l10n.originalImage,
            style: const TextStyle(
              fontFamily: 'Playfair',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              provider.originalImage!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),

          // Stylized Image (if available)
          if (provider.stylizedImageBytes != null) ...[
            Text(
              l10n.stylizedImage,
              style: const TextStyle(
                fontFamily: 'Playfair',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(
                provider.stylizedImageBytes!,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.imageStylizedSuccessfully(widget.artist),
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 13,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Style Transfer Info (fallback if no image was generated)
          if (provider.styleTransferPrompt != null &&
              provider.stylizedImageBytes == null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.aiStyleTransferGuide,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    provider.styleTransferPrompt!,
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.aiStyleGuideNote(widget.artist),
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

          if (provider.styleTransferPrompt != null &&
              provider.stylizedImageBytes == null)
            const SizedBox(height: 24),

          // Action buttons
          if (provider.stylizedImageBytes != null) ...[
            // Share and Save buttons (only show if image was generated)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _shareImage(provider.stylizedImageBytes!, l10n),
                    icon: const Icon(Icons.share),
                    label: Text(l10n.share),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _saveImage(provider.stylizedImageBytes!, l10n),
                    icon: const Icon(Icons.download),
                    label: Text(l10n.save),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
