import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service for interacting with Replicate API
/// Used as a fallback when Gemini image generation fails
class ReplicateService {
  final Dio _dio;
  final String _apiToken;
  static const String _baseUrl = 'https://api.replicate.com/v1';

  ReplicateService()
      : _apiToken = dotenv.env['REPLICATE_API_TOKEN'] ?? '',
        _dio = Dio(BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout:
              const Duration(minutes: 5), // Image generation can take time
          headers: {
            'Content-Type': 'application/json',
          },
        )) {
    log('🔧 ReplicateService: Initializing service...');

    if (_apiToken.isEmpty) {
      log('⚠️ ReplicateService: REPLICATE_API_TOKEN not found in .env file');
      log('   Replicate fallback will not be available');
    } else {
      log('✅ ReplicateService: API token found (length: ${_apiToken.length})');
      _dio.options.headers['Authorization'] = 'Bearer $_apiToken';
    }

    log('✅ ReplicateService: Service initialization complete');
  }

  /// Check if Replicate service is available (has valid API token)
  bool get isAvailable => _apiToken.isNotEmpty;

  /// Generate a stylized image using Replicate's nano-banana model
  ///
  /// This method:
  /// 1. Uploads the image to a temporary URL (or uses base64)
  /// 2. Sends a prediction request to Replicate
  /// 3. Waits for the prediction to complete
  /// 4. Downloads and returns the generated image
  Future<Uint8List?> stylizeImage({
    required Uint8List imageBytes,
    required String artistStyle,
    required String artworkTitle,
  }) async {
    if (!isAvailable) {
      log('❌ ReplicateService: Service not available (missing API token)');
      throw Exception('Replicate API token not configured');
    }

    try {
      log('🎨 ReplicateService: Starting image stylization');
      log('   Artist style: $artistStyle');
      log('   Artwork title: $artworkTitle');
      log('   Image size: ${imageBytes.length} bytes');

      // Convert image to base64 data URI
      final base64Image = base64Encode(imageBytes);
      final dataUri = 'data:image/jpeg;base64,$base64Image';
      log('✅ ReplicateService: Image converted to base64 data URI');

      // Create the prompt for style transfer
      final prompt =
          '''Transform this image to match the distinctive artistic style of $artistStyle, inspired by their work "$artworkTitle". Apply their signature techniques including brushwork, color palette, composition style, and aesthetic sensibilities. Maintain the subject matter while fully embracing $artistStyle's artistic approach. Make the scene natural and artistic.''';

      log('📝 ReplicateService: Prompt created (${prompt.length} chars)');

      // Create prediction request
      final requestBody = {
        'input': {
          'prompt': prompt,
          'image_input': [
            dataUri, // The user's image
          ],
        },
      };

      log('🚀 ReplicateService: Sending prediction request to nano-banana...');

      // Send request to create prediction
      final response = await _dio.post(
        '/models/google/nano-banana/predictions',
        data: requestBody,
      );

      log('📥 ReplicateService: Response received');
      log('   Status code: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        log('❌ ReplicateService: Unexpected status code: ${response.statusCode}');
        throw Exception('Failed to create prediction: ${response.statusCode}');
      }

      final responseData = response.data as Map<String, dynamic>;
      log('   Response data keys: ${responseData.keys.join(", ")}');

      final predictionId = responseData['id'] as String?;
      final initialStatus = responseData['status'] as String?;
      log('   Prediction ID: $predictionId');
      log('   Initial status: $initialStatus');

      if (predictionId == null) {
        log('❌ ReplicateService: No prediction ID in response');
        throw Exception('No prediction ID returned');
      }

      // If status is already succeeded, use the result directly
      // Otherwise, poll for completion
      Map<String, dynamic> finalResult;
      if (initialStatus == 'succeeded') {
        log('✅ ReplicateService: Prediction completed immediately');
        finalResult = responseData;
      } else {
        log('🔄 ReplicateService: Prediction not ready, starting polling...');
        finalResult = await _pollPrediction(predictionId);
      }

      final status = finalResult['status'] as String?;
      log('   Final prediction status: $status');

      if (status == 'succeeded') {
        // Get the output image URL
        final output = finalResult['output'];
        log('   Output type: ${output.runtimeType}');

        String? imageUrl;
        if (output is String) {
          imageUrl = output;
        } else if (output is List && output.isNotEmpty) {
          imageUrl = output.first as String?;
        }

        if (imageUrl == null || imageUrl.isEmpty) {
          log('❌ ReplicateService: No output image URL in response');
          throw Exception('No output image URL in response');
        }

        log('✅ ReplicateService: Got output image URL');
        log('   URL: ${imageUrl.substring(0, imageUrl.length > 50 ? 50 : imageUrl.length)}...');

        // Download the generated image
        log('📥 ReplicateService: Downloading generated image...');
        final imageResponse = await _dio.get(
          imageUrl,
          options: Options(
            responseType: ResponseType.bytes,
          ),
        );

        if (imageResponse.statusCode != 200) {
          log('❌ ReplicateService: Failed to download image: ${imageResponse.statusCode}');
          throw Exception('Failed to download generated image');
        }

        final generatedImageBytes =
            Uint8List.fromList(imageResponse.data as List<int>);
        log('✅ ReplicateService: Image downloaded successfully');
        log('   Size: ${generatedImageBytes.length} bytes');
        log('🎉 ReplicateService: Image stylization completed successfully!');

        return generatedImageBytes;
      } else if (status == 'failed') {
        final error = finalResult['error'] as String?;
        log('❌ ReplicateService: Prediction failed: $error');
        throw Exception('Prediction failed: $error');
      } else if (status == 'canceled') {
        log('❌ ReplicateService: Prediction was canceled');
        throw Exception('Prediction was canceled');
      } else {
        log('⚠️ ReplicateService: Unexpected final status: $status');
        throw Exception('Prediction in unexpected state: $status');
      }
    } on DioException catch (e) {
      log('❌ ReplicateService: DioException occurred');
      log('   Type: ${e.type}');
      log('   Message: ${e.message}');
      if (e.response != null) {
        log('   Response status: ${e.response?.statusCode}');
        log('   Response data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      log('❌ ReplicateService: Error stylizing image: $e');
      log('   Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  /// Poll for prediction status until completion
  /// Replicate doesn't support synchronous requests, so we need to poll
  Future<Map<String, dynamic>> _pollPrediction(String predictionId) async {
    log('🔄 ReplicateService: Polling prediction status...');
    log('   Prediction ID: $predictionId');

    const maxAttempts = 120; // 10 minutes max (5 seconds * 120)
    const pollInterval = Duration(seconds: 5);

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      log('   Attempt $attempt/$maxAttempts');

      final response = await _dio.get('/predictions/$predictionId');

      if (response.statusCode != 200) {
        log('❌ ReplicateService: Failed to get prediction status: ${response.statusCode}');
        throw Exception('Failed to get prediction status');
      }

      final data = response.data as Map<String, dynamic>;
      final status = data['status'] as String?;

      log('   Status: $status');

      if (status == 'succeeded' || status == 'failed' || status == 'canceled') {
        log('✅ ReplicateService: Prediction completed with status: $status');
        return data;
      }

      // Wait before next poll
      if (attempt < maxAttempts) {
        log('   Waiting ${pollInterval.inSeconds}s before next poll...');
        await Future.delayed(pollInterval);
      }
    }

    log('❌ ReplicateService: Prediction timed out after $maxAttempts attempts');
    throw Exception('Prediction timed out');
  }
}
