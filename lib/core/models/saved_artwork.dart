class SavedArtwork {
  final String id; // Cambiar de int? a String para consistencia
  final String title;
  final String imageUrl;
  final String description;
  final DateTime savedAt;

  SavedArtwork({
    required this.id, // Ahora es requerido
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory SavedArtwork.fromMap(Map<String, dynamic> map) {
    return SavedArtwork(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      description: map['description'],
      savedAt: DateTime.parse(map['savedAt']),
    );
  }
}
