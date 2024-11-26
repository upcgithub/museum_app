class MuseumService {
  Future<List<Map<String, dynamic>>> getPopularArtworks() async {
    // Simulated data - replace with actual API call
    return [
      {
        'id': '1',
        'title': 'Anatomie des Dr. Tulp',
        'artist': 'Rembrandt',
        'imageUrl':
            'https://www.reprodart.com/kunst/rembrandt_hamerszoon_van_rijn/anatomie-des-dr-tulp.jpg',
        'type': 'Painting',
      },
      {
        'id': '2',
        'title': 'Vink',
        'artist': 'Jan Fabritius',
        'imageUrl':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Fabritius-vink.jpg/490px-Fabritius-vink.jpg',
        'type': 'Painting',
      },
      {
        'id': '3',
        'title': 'Anatomie des Dr. Tulp',
        'artist': 'Rembrandt',
        'imageUrl':
            'https://www.reprodart.com/kunst/rembrandt_hamerszoon_van_rijn/anatomie-des-dr-tulp.jpg',
        'type': 'Painting',
      },
      {
        'id': '4',
        'title': 'Anatomie des Dr. Tulp',
        'artist': 'Rembrandt',
        'imageUrl':
            'https://www.reprodart.com/kunst/rembrandt_hamerszoon_van_rijn/anatomie-des-dr-tulp.jpg',
        'type': 'Painting',
      },
    ];
  }
}
