class SavedArtwork {
  final String id; // Cambiar de int? a String para consistencia
  final String title;
  final String imageUrl;
  final String description;
  final String artist;
  final DateTime savedAt;
  final String userId; // ID del usuario que guardó la obra

  SavedArtwork({
    required this.id, // Ahora es requerido
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.artist,
    required this.savedAt,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'imageUrl': imageUrl,
      'description': description,
      'savedAt': savedAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory SavedArtwork.fromMap(Map<String, dynamic> map) {
    return SavedArtwork(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      description: map['description'],
      artist: map['artist'],
      savedAt: DateTime.parse(map['savedAt']),
      userId: map['userId'],
    );
  }
}
