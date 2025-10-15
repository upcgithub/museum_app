class StylizedPhoto {
  final String id;
  final String filePath;
  final String artistName;
  final String artworkTitle;
  final DateTime createdAt;
  final String? thumbnailPath;

  StylizedPhoto({
    required this.id,
    required this.filePath,
    required this.artistName,
    required this.artworkTitle,
    required this.createdAt,
    this.thumbnailPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filePath': filePath,
      'artistName': artistName,
      'artworkTitle': artworkTitle,
      'createdAt': createdAt.toIso8601String(),
      'thumbnailPath': thumbnailPath,
    };
  }

  factory StylizedPhoto.fromMap(Map<String, dynamic> map) {
    return StylizedPhoto(
      id: map['id'] as String,
      filePath: map['filePath'] as String,
      artistName: map['artistName'] as String,
      artworkTitle: map['artworkTitle'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      thumbnailPath: map['thumbnailPath'] as String?,
    );
  }

  StylizedPhoto copyWith({
    String? id,
    String? filePath,
    String? artistName,
    String? artworkTitle,
    DateTime? createdAt,
    String? thumbnailPath,
  }) {
    return StylizedPhoto(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      artistName: artistName ?? this.artistName,
      artworkTitle: artworkTitle ?? this.artworkTitle,
      createdAt: createdAt ?? this.createdAt,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }
}
