import 'dart:io';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:museum_app/core/services/gemini_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class GeminiProvider extends ChangeNotifier {
  final GeminiService _geminiService;

  // Chat state
  ChatSession? _currentChatSession;
  List<ChatMessage> _chatHistory = [];
  bool _isChatLoading = false;
  String? _chatError;

  // Style transfer state
  bool _isStyleTransferLoading = false;
  String? _styleTransferError;
  Uint8List? _stylizedImageBytes;
  File? _originalImage;
  String? _styleTransferPrompt;

  // Current artwork context
  String? _currentArtist;
  String? _currentArtworkTitle;

  GeminiProvider(this._geminiService);

  // Getters
  List<ChatMessage> get chatHistory => _chatHistory;
  bool get isChatLoading => _isChatLoading;
  String? get chatError => _chatError;
  bool get isStyleTransferLoading => _isStyleTransferLoading;
  String? get styleTransferError => _styleTransferError;
  Uint8List? get stylizedImageBytes => _stylizedImageBytes;
  File? get originalImage => _originalImage;
  String? get styleTransferPrompt => _styleTransferPrompt;
  String? get currentArtist => _currentArtist;
  String? get currentArtworkTitle => _currentArtworkTitle;

  /// Initialize a new chat session with an artist
  void initializeChatSession({
    required String artist,
    required String artworkTitle,
    required String description,
    required String languageCode,
  }) {
    log('🎭 GeminiProvider: Initializing chat session');
    log('   Artist: $artist');
    log('   Artwork: $artworkTitle');
    log('   Language: $languageCode');

    _currentArtist = artist;
    _currentArtworkTitle = artworkTitle;
    _chatHistory = [];
    _chatError = null;

    log('🔧 GeminiProvider: Creating chat session via service...');
    _currentChatSession = _geminiService.createArtistChat(
      artist: artist,
      artworkTitle: artworkTitle,
      description: description,
      languageCode: languageCode,
    );

    // Add welcome message in the appropriate language
    final welcomeMessage = languageCode == 'es'
        ? 'Hola! Soy $artist. Siéntete libre de preguntarme sobre "$artworkTitle" o cualquiera de mis otras obras.'
        : 'Hello! I am $artist. Feel free to ask me about "$artworkTitle" or any of my other works.';

    _chatHistory.add(ChatMessage(
      text: welcomeMessage,
      isUser: false,
      timestamp: DateTime.now(),
    ));

    log('✅ GeminiProvider: Chat session initialized with welcome message');
    log('   Chat history length: ${_chatHistory.length}');
    notifyListeners();
  }

  /// Send a message in the current chat session
  Future<void> sendChatMessage(String message) async {
    log('💬 GeminiProvider: sendChatMessage called');
    log('   Message: "$message"');
    log('   Session exists: ${_currentChatSession != null}');

    if (_currentChatSession == null || message.trim().isEmpty) {
      log('⚠️ GeminiProvider: Cannot send message - session null or message empty');
      return;
    }

    // Add user message to history
    log('📝 GeminiProvider: Adding user message to history');
    _chatHistory.add(ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    _isChatLoading = true;
    _chatError = null;
    log('🔄 GeminiProvider: Set loading state, notifying listeners');
    notifyListeners();

    try {
      log('🚀 GeminiProvider: Calling service.sendMessage...');
      final response = await _geminiService.sendMessage(
        _currentChatSession!,
        message,
      );

      log('✅ GeminiProvider: Response received from service');
      log('   Response length: ${response.length} chars');

      // Add AI response to history
      _chatHistory.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));

      log('✅ GeminiProvider: AI response added to history');
      log('   Total messages: ${_chatHistory.length}');
    } catch (e) {
      log('❌ GeminiProvider: Error sending message: $e');
      _chatError = 'Failed to send message. Please try again.';
      // Remove the user message if the request failed
      if (_chatHistory.isNotEmpty && _chatHistory.last.isUser) {
        log('🔄 GeminiProvider: Removing failed user message from history');
        _chatHistory.removeLast();
      }
    } finally {
      _isChatLoading = false;
      log('✅ GeminiProvider: Chat operation complete, notifying listeners');
      notifyListeners();
    }
  }

  /// Clear chat history and session
  void clearChatSession() {
    log('🧹 GeminiProvider: Clearing chat session');
    log('   Previous history length: ${_chatHistory.length}');
    _currentChatSession = null;
    _chatHistory = [];
    _chatError = null;
    _currentArtist = null;
    _currentArtworkTitle = null;
    log('✅ GeminiProvider: Chat session cleared');
    notifyListeners();
  }

  /// Retry last failed message
  Future<void> retryChatMessage() async {
    if (_chatHistory.isEmpty) return;

    // Find the last user message
    for (int i = _chatHistory.length - 1; i >= 0; i--) {
      if (_chatHistory[i].isUser) {
        final lastUserMessage = _chatHistory[i].text;
        await sendChatMessage(lastUserMessage);
        break;
      }
    }
  }

  /// Start style transfer process
  Future<void> startStyleTransfer({
    required File image,
    required String artistStyle,
    required String artworkTitle,
  }) async {
    _originalImage = image;
    _isStyleTransferLoading = true;
    _styleTransferError = null;
    _stylizedImageBytes = null;
    _styleTransferPrompt = null;
    notifyListeners();

    try {
      // Use gemini-2.5-flash-image to generate the stylized image directly
      final stylizedBytes = await _geminiService.stylizeImage(
        image: image,
        artistStyle: artistStyle,
        artworkTitle: artworkTitle,
      );

      if (stylizedBytes != null) {
        _stylizedImageBytes = stylizedBytes;
      } else {
        // Fallback: if image generation fails, get a style transfer prompt
        final prompt = await _geminiService.getStyleTransferPrompt(
          artistStyle: artistStyle,
          artworkTitle: artworkTitle,
        );
        _styleTransferPrompt = prompt;
      }
    } catch (e) {
      _styleTransferError =
          'Failed to generate style transfer. Please try again.';
    } finally {
      _isStyleTransferLoading = false;
      notifyListeners();
    }
  }

  /// Clear style transfer state
  void clearStyleTransfer() {
    log('🧹 GeminiProvider: Clearing style transfer state');
    _stylizedImageBytes = null;
    _originalImage = null;
    _styleTransferError = null;
    _styleTransferPrompt = null;
    log('✅ GeminiProvider: Style transfer state cleared');
    notifyListeners();
  }
}
