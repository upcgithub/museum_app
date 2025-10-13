import 'dart:io';
import 'dart:typed_data';
import 'dart:developer';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:museum_app/core/services/replicate_service.dart';

class GeminiService {
  late final GenerativeModel _chatModel;
  late final GenerativeModel _imageModel;
  final String _apiKey;
  late final ReplicateService _replicateService;

  GeminiService() : _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '' {
    log('🔧 GeminiService: Initializing service...');

    if (_apiKey.isEmpty) {
      log('❌ GeminiService: GEMINI_API_KEY not found in .env file');
      throw Exception('GEMINI_API_KEY not found in .env file');
    }

    log('✅ GeminiService: API key found (length: ${_apiKey.length})');

    // Initialize chat model
    log('🤖 GeminiService: Initializing chat model (gemini-2.0-flash-exp)');
    _chatModel = GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.9,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048,
      ),
    );
    log('✅ GeminiService: Chat model initialized');

    // Initialize image generation model
    log('🎨 GeminiService: Initializing image model (gemini-2.5-flash-image)');
    _imageModel = GenerativeModel(
      model: 'gemini-2.5-flash-image',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 32,
        topP: 0.9,
        //maxOutputTokens: 2048,
      ),
    );
    log('✅ GeminiService: Image model initialized');

    // Initialize Replicate service as fallback
    log('🔄 GeminiService: Initializing Replicate fallback service...');
    _replicateService = ReplicateService();
    if (_replicateService.isAvailable) {
      log('✅ GeminiService: Replicate fallback service available');
    } else {
      log('⚠️ GeminiService: Replicate fallback service not available (missing token)');
    }

    log('🎉 GeminiService: Service initialization complete');
  }

  /// Creates a chat session with the artist persona
  ChatSession createArtistChat({
    required String artist,
    required String artworkTitle,
    required String description,
    required String languageCode,
  }) {
    log('💬 GeminiService: Creating artist chat session');
    log('   Artist: $artist');
    log('   Artwork: $artworkTitle');
    log('   Language: $languageCode');
    log('   Description length: ${description.length} chars');

    // Determinar el idioma para el prompt
    final languageInstruction = languageCode == 'es'
        ? 'IMPORTANTE: Responde SIEMPRE en español. Toda tu conversación debe ser en español.'
        : 'IMPORTANT: Always respond in English. All your conversation should be in English.';

    final languageName = languageCode == 'es' ? 'español' : 'English';

    final systemPrompt =
        '''You are $artist, the creator of "$artworkTitle". You speak in first person about your work, techniques, inspirations, and historical context. Be authentic to the artist's known style, period, and philosophy. Answer questions about this specific artwork and your broader body of work. Keep responses conversational, insightful, and historically accurate.

$languageInstruction

Artwork Context:
$description

Remember to stay in character as $artist and provide thoughtful, engaging responses that reflect the artist's perspective and time period. Always respond in $languageName.''';

    log('📝 GeminiService: System prompt created (${systemPrompt.length} chars)');
    log('   Language instruction: $languageInstruction');

    final welcomeMessage = languageCode == 'es'
        ? 'Entiendo. Soy $artist, y estoy aquí para hablar sobre "$artworkTitle" y mi trayectoria artística. Siéntete libre de preguntarme sobre mi trabajo, técnicas o inspiraciones.'
        : 'I understand. I am $artist, and I\'m here to discuss "$artworkTitle" and my artistic journey. Feel free to ask me anything about my work, techniques, or inspirations.';

    final history = [
      Content.text(systemPrompt),
      Content.model([TextPart(welcomeMessage)]),
    ];

    log('✅ GeminiService: Chat session created with ${history.length} initial messages');
    return _chatModel.startChat(history: history);
  }

  /// Sends a message in the chat session and returns the response
  Future<String> sendMessage(ChatSession session, String message) async {
    try {
      log('📤 GeminiService: Sending message to chat');
      log('   Message: "${message.substring(0, message.length > 50 ? 50 : message.length)}${message.length > 50 ? '...' : ''}"');
      log('   Message length: ${message.length} chars');

      final response = await session.sendMessage(Content.text(message));

      log('📥 GeminiService: Received response from Gemini');
      log('   Response candidates: ${response.candidates.length}');

      if (response.text == null || response.text!.isEmpty) {
        log('❌ GeminiService: Empty response from Gemini');
        throw Exception('Empty response from Gemini');
      }

      log('✅ GeminiService: Response text received (${response.text!.length} chars)');
      log('   Response preview: "${response.text!.substring(0, response.text!.length > 100 ? 100 : response.text!.length)}${response.text!.length > 100 ? '...' : ''}"');
      return response.text!;
    } catch (e) {
      log('❌ GeminiService: Error sending message: $e');
      rethrow;
    }
  }

  /// Applies artist style to an uploaded photo using gemini-2.5-flash-image
  /// This model can generate actual images based on the input image and prompt
  /// Falls back to Replicate's nano-banana model if Gemini fails
  /// Note: Always uses English for better image generation results
  Future<Uint8List?> stylizeImage({
    required File image,
    required String artistStyle,
    required String artworkTitle,
  }) async {
    Uint8List? imageBytes;

    try {
      log('🎨 GeminiService: Starting image stylization');
      log('   Artist style: $artistStyle');
      log('   Artwork title: $artworkTitle');
      log('   Image path: ${image.path}');

      imageBytes = await image.readAsBytes();
      log('✅ GeminiService: Image loaded (${imageBytes.length} bytes)');

      // Always use English for image generation (works better)
      final prompt =
          '''Transform this image to match the distinctive artistic style of $artistStyle. Apply their signature techniques including brushwork, color palette, composition style, and aesthetic sensibilities seen in works like "$artworkTitle". Maintain the subject matter while fully embracing $artistStyle's artistic approach. Create a beautiful artistic interpretation that honors $artistStyle's legacy.''';

      log('📝 GeminiService: Prompt created (${prompt.length} chars) [English for better results]');
      log('   Prompt: "${prompt.substring(0, prompt.length > 100 ? 100 : prompt.length)}..."');

      final imagePart = DataPart('image/jpeg', imageBytes);
      final textPart = TextPart(prompt);
      log('✅ GeminiService: Content parts created (text + image)');

      // gemini-2.5-flash-image can generate images from text + image input
      log('🚀 GeminiService: Sending request to gemini-2.5-flash-image...');
      final response = await _imageModel.generateContent([
        Content.multi([textPart, imagePart])
      ]);
      log('📥 GeminiService: Response received from Gemini');

      // Extract the generated image from the response
      // The image is returned as a DataPart with inline data
      final candidates = response.candidates;
      log('   Candidates count: ${candidates.length}');

      if (candidates.isNotEmpty) {
        log('   Processing first candidate...');
        final parts = candidates.first.content.parts;
        log('   Parts count: ${parts.length}');

        for (int i = 0; i < parts.length; i++) {
          final part = parts[i];
          log('   Part $i type: ${part.runtimeType}');

          // Check if this part is a DataPart (contains image data)
          if (part is DataPart) {
            final bytes = part.bytes;
            log('✅ GeminiService: Image found in part $i');
            log('   Image size: ${bytes.length} bytes');
            log('🎉 GeminiService: Image stylization completed successfully with Gemini!');
            return bytes;
          } else if (part is TextPart) {
            log('   Part $i is TextPart: "${part.text.substring(0, part.text.length > 50 ? 50 : part.text.length)}..."');
          }
        }
      } else {
        log('⚠️ GeminiService: No candidates in response');
      }

      // If we got text instead of an image, log it for debugging
      final responseText = response.text;
      if (responseText != null && responseText.isNotEmpty) {
        log('⚠️ GeminiService: Gemini returned text instead of image');
        log('   Text: "${responseText.substring(0, responseText.length > 200 ? 200 : responseText.length)}..."');
      }

      // If no image was generated, throw an error to trigger fallback
      log('❌ GeminiService: No image data found in Gemini response');
      throw Exception(
          'Failed to generate stylized image - no image data returned');
    } catch (e) {
      log('❌ GeminiService: Gemini image generation failed: $e');
      log('   Error type: ${e.runtimeType}');

      // Try Replicate as fallback
      if (_replicateService.isAvailable && imageBytes != null) {
        log('🔄 GeminiService: Attempting fallback to Replicate...');
        try {
          final replicateResult = await _replicateService.stylizeImage(
            imageBytes: imageBytes,
            artistStyle: artistStyle,
            artworkTitle: artworkTitle,
          );

          if (replicateResult != null) {
            log('🎉 GeminiService: Image stylization completed successfully with Replicate fallback!');
            return replicateResult;
          }
        } catch (replicateError) {
          log('❌ GeminiService: Replicate fallback also failed: $replicateError');
          // Continue to rethrow original error
        }
      } else {
        log('⚠️ GeminiService: Replicate fallback not available');
      }

      // If both failed, rethrow the original error
      rethrow;
    }
  }

  /// Alternative method: Get style transfer prompt for external image generation
  /// Note: Always uses English for better image generation results
  Future<String> getStyleTransferPrompt({
    required String artistStyle,
    required String artworkTitle,
  }) async {
    try {
      log('📝 GeminiService: Generating style transfer prompt (fallback)');
      log('   Artist: $artistStyle');
      log('   Artwork: $artworkTitle');

      // Always use English for image generation (works better)
      final prompt =
          '''Generate a detailed prompt for an AI image generator to transform any input image into the artistic style of $artistStyle, inspired by their work "$artworkTitle". Include specific details about:
1. Color palette and tones
2. Brushwork and texture techniques
3. Composition and perspective style
4. Lighting and shadow approach
5. Any signature techniques of $artistStyle

Make the prompt detailed and specific so it can guide accurate style transfer. Respond in English.''';

      log('🚀 GeminiService: Sending prompt generation request [English for better results]...');
      final response = await _chatModel.generateContent([Content.text(prompt)]);
      log('📥 GeminiService: Response received');

      if (response.text == null || response.text!.isEmpty) {
        log('❌ GeminiService: Empty response for style transfer prompt');
        throw Exception('Failed to generate style transfer prompt');
      }

      log('✅ GeminiService: Style transfer prompt generated (${response.text!.length} chars)');
      return response.text!;
    } catch (e) {
      log('❌ GeminiService: Error generating style transfer prompt: $e');
      rethrow;
    }
  }
}
