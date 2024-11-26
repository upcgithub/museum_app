class MuseumService {
  Future<List<Map<String, dynamic>>> getPopularArtworks() async {
    // Simulated data - replace with actual API call
    return [
      {
        'id': '1',
        'title': 'The Night Watch',
        'artist': 'Rembrandt',
        'imageUrl': 'https://example.com/night-watch.jpg',
        'type': 'Painting',
      },
      // Add more items...
    ];
  }
}
