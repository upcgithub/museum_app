import 'package:museum_app/domain/entities/artwork.dart';

class MuseumService {
  Future<List<Artwork>> getPopularArtworks() async {
    final List<Map<String, dynamic>> rawData = [
      {
        'id': '1',
        'title': 'Anatomie des Dr. Tulp',
        'artist': 'Rembrandt',
        'imageUrl':
            'https://www.reprodart.com/kunst/rembrandt_hamerszoon_van_rijn/anatomie-des-dr-tulp.jpg',
        'type': 'Permanent Exhibition',
      },
      {
        'id': '2',
        'title': 'Vink',
        'artist': 'Jan Fabritius',
        'imageUrl':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Fabritius-vink.jpg/490px-Fabritius-vink.jpg',
        'type': 'Permanent Exhibition',
      },
      {
        'id': '3',
        'title': 'Anatomie des Dr. Tulp',
        'artist': 'Rembrandt',
        'imageUrl':
            'https://www.reprodart.com/kunst/rembrandt_hamerszoon_van_rijn/anatomie-des-dr-tulp.jpg',
        'type': 'Temporary Exhibition',
      },
      {
        'id': '4',
        'title': 'Anatomie des Dr. Tulp',
        'artist': 'Rembrandt',
        'imageUrl':
            'https://www.reprodart.com/kunst/rembrandt_hamerszoon_van_rijn/anatomie-des-dr-tulp.jpg',
        'type': 'Temporary Exhibition',
      },
    ];

    return rawData.map((data) => Artwork.fromMap(data)).toList();
  }

  Future<List<Artwork>> getWhatsNewArtworks() async {
    await Future.delayed(const Duration(seconds: 1));

    final List<Map<String, dynamic>> rawData = [
      {
        'id': '5',
        'title': 'The Night Watch',
        'artist': 'Rembrandt van Rijn',
        'imageUrl':
            'https://i.guim.co.uk/img/media/5255be4caf692083ff5874ffcb9d6c2693c45af3/0_1076_4594_2755/master/4594.jpg?width=620&dpr=2&s=none&crop=none',
        'type': 'Permanent Exhibition',
        'description': 'New exhibition featuring The Night Watch',
      },
      {
        'id': '6',
        'title': 'Girl with a Pearl Earring',
        'artist': 'Johannes Vermeer',
        'imageUrl':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Meisje_met_de_parel.jpg/1920px-Meisje_met_de_parel.jpg',
        'type': 'Temporary Exhibition',
        'description': 'Special exhibition of Dutch Golden Age',
      },
      {
        'id': '7',
        'title': 'The Milkmaid',
        'artist': 'Johannes Vermeer',
        'imageUrl':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/Vermeer%2C_Johannes_-_Woman_reading_a_letter_-_ca._1662-1663.jpg/1920px-Vermeer%2C_Johannes_-_Woman_reading_a_letter_-_ca._1662-1663.jpg',
        'type': 'Permanent Exhibition',
        'description': 'New restoration revealed',
      },
    ];

    return rawData.map((data) => Artwork.fromMap(data)).toList();
  }
}
