class Artwork {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final String type;
  final String? description;

  Artwork({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.type,
    this.description,
  });

  // Factory constructor para crear desde Map
  factory Artwork.fromMap(Map<String, dynamic> map) {
    return Artwork(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      imageUrl: map['imageUrl'] as String,
      type: map['type'] as String,
      description: map['description'] as String?,
    );
  }

  // Método para convertir a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'imageUrl': imageUrl,
      'type': type,
      'description': description,
    };
  }
}
