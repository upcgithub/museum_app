import 'package:museum_app/domain/entities/artwork.dart';

class MuseumService {
  Future<List<Artwork>> getPopularArtworks() async {
    final List<Map<String, dynamic>> rawData = [
      {
        "id": "1",
        "title": "Anatomy Lesson of Dr. Tulp",
        "artist": "Rembrandt",
        "imageUrl":
            "https://www.reprodart.com/kunst/rembrandt_hamerszoon_van_rijn/anatomie-des-dr-tulp.jpg",
        "type": "Permanent Exhibition",
        "description":
            "La Lección de Anatomía del Dr. Tulp, pintada en 1632, es una de las obras más icónicas de Rembrandt y una obra maestra de la Edad de Oro Neerlandesa. Este cuadro retrata una lección pública de anatomía, donde el Dr. Nicolaes Tulp explica las complejidades de la mano humana. Cada figura está representada con expresiones únicas que reflejan curiosidad, estudio y respeto por la ciencia.\n\nLa composición se centra en el Dr. Tulp, iluminado por una luz dramática que contrasta con las sombras circundantes. Este uso del claroscuro crea una atmósfera casi teatral, que refleja el genio de Rembrandt para evocar emoción y profundidad.\n\nEsta obra no solo documenta un evento científico, sino que también destaca la importancia del progreso en el conocimiento médico durante el siglo XVII. Es un tributo al espíritu inquisitivo y a la capacidad de la humanidad para comprender su propia anatomía."
      },
      {
        "id": "2",
        "title": "Chaffinch",
        "artist": "Jan Fabritius",
        "imageUrl":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Fabritius-vink.jpg/490px-Fabritius-vink.jpg",
        "type": "Permanent Exhibition",
        "description":
            "Chaffinch, created by Jan Fabritius, stands out for its meticulous depiction of a small finch (known as 'vink' in Dutch). The level of detail in the plumage and the delicate posture of the bird reflect the artist's skill in capturing nature with scientific accuracy and artistic sensitivity.\n\nThe simple composition, with the bird as the central focus, highlights the beauty in the everyday. The use of soft colors and attention to the natural environment suggest an intimate connection between art and the observation of the natural world.\n\nThis piece is part of a Dutch painting tradition that celebrates local wildlife, elevating even the humblest subjects to a state of sublime art. Chaffinch invites contemplation and appreciation of the small details in nature."
      },
      {
        "id": "3",
        "title": "The Penitent Magdalene",
        "artist": "Georges de La Tour",
        "imageUrl":
            "https://educacion.ufm.edu/wp-content/uploads/2013/05/Georges_de_La_Tour_007.jpg",
        "type": "Special Exhibition",
        "description":
            "The Penitent Magdalene is one of Georges de La Tour's most captivating works, painted in the 17th century. This Baroque masterpiece depicts Mary Magdalene in a moment of deep introspection, seated in front of a candle whose warm light softly illuminates the scene. Her hand rests on a skull, symbolizing mortality and repentance.\n\nThe composition reflects La Tour's mastery of creating dramatic contrasts through chiaroscuro. The surrounding darkness of the room contrasts with the candlelight, which delicately outlines Magdalene's figure. This effect not only emphasizes the meditative atmosphere but also underscores the fleeting nature of life.\n\nThe painting invites viewers to reflect on themes such as repentance, spirituality, and human fragility. It remains one of La Tour's most iconic pieces and a masterful example of his ability to combine simplicity with profound emotional depth in his art."
      },
      {
        "id": "4",
        "title": "The Starry Night",
        "artist": "Vincent van Gogh",
        "imageUrl":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/440px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg",
        "type": "Permanent Exhibition",
        "description":
            "The Starry Night, painted in 1889 by Vincent van Gogh, is one of the most recognizable works in the history of Western art. This masterpiece portrays a turbulent night sky filled with swirling clouds, bright stars, and a radiant crescent moon, all painted with Van Gogh's iconic thick brushstrokes.\n\nThe painting captures a view from the window of Van Gogh's asylum room in Saint-Rémy-de-Provence, France. The vibrant colors and emotional intensity of the work reflect Van Gogh's inner turmoil and his fascination with the cosmos. The cypress trees in the foreground reach upwards, creating a connection between the earth and the heavens.\n\nThe Starry Night is celebrated not only for its visual impact but also for its emotional depth. It has inspired countless interpretations and remains a symbol of Van Gogh's artistic genius and his ability to convey the complexity of human emotion through art."
      },
    ];

    return rawData.map((data) => Artwork.fromMap(data)).toList();
  }

  Future<List<Artwork>> getWhatsNewArtworks() async {
    await Future.delayed(const Duration(seconds: 1));

    final List<Map<String, dynamic>> rawData = [
      {
        "id": "5",
        "title": "The Night Watch",
        "artist": "Rembrandt van Rijn",
        "imageUrl":
            "https://i.guim.co.uk/img/media/5255be4caf692083ff5874ffcb9d6c2693c45af3/0_1076_4594_2755/master/4594.jpg?width=620&dpr=2&s=none&crop=none",
        "type": "Permanent Exhibition",
        "description":
            "The Night Watch is one of Rembrandt van Rijn's most iconic masterpieces and a pivotal work in art history. Painted in 1642, this colossal canvas depicts the Amsterdam civic guard, showcasing Rembrandt's exceptional skill in capturing movement, light, and shadow. The innovative use of light directs the viewer's focus to Captain Frans Banning Cocq and his lieutenant, Willem van Ruytenburch, surrounded by a bustling scene of guardsmen and symbolic figures.\n\nThe painting's dynamic composition and attention to detail make it a groundbreaking example of Baroque art. Rembrandt's use of chiaroscuro—the dramatic interplay between light and dark—adds depth and intensity, highlighting the individuality of each figure. The lively atmosphere and layered symbolism invite viewers to explore the complex narrative within the scene.\n\nOver the centuries, The Night Watch has undergone several restorations and remains a source of fascination for art historians and enthusiasts alike. Its recent inclusion in the 'Operation Night Watch' project aims to preserve and uncover more details about its creation, ensuring its legacy endures for future generations."
      },
      {
        "id": "6",
        "title": "Girl with a Pearl Earring",
        "artist": "Johannes Vermeer",
        "imageUrl":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Meisje_met_de_parel.jpg/1920px-Meisje_met_de_parel.jpg",
        "type": "Temporary Exhibition",
        "description":
            "A menudo llamada la 'Mona Lisa del Norte', La Joven de la Perla es una de las obras más enigmáticas y queridas de Johannes Vermeer. Creada alrededor de 1665, este cautivador retrato captura a una joven con un turbante azul y amarillo llamativo y un pendiente de perla sobredimensionado. Su mirada directa y su expresión sutil han intrigado a los espectadores durante siglos, generando infinitas interpretaciones sobre su identidad y las intenciones de Vermeer.\n\nEl dominio de Vermeer sobre la luz y la textura es evidente en esta pintura, con transiciones suaves y detalles delicados que dan vida al sujeto. La calidad luminosa de la perla y los pliegues intrincados de la tela muestran su habilidad inigualable para representar la materialidad. La simplicidad de la composición, combinada con su profundidad emocional, la convierten en una obra maestra atemporal.\n\nEsta exposición temporal invita a los visitantes a profundizar en el contexto histórico y cultural de la Edad de Oro neerlandesa mientras aprecian la habilidad única de Vermeer para transmitir misterio e intimidad. También destaca investigaciones recientes y descubrimientos sobre la pintura, incluidos los pigmentos utilizados y las posibles inspiraciones detrás de su creación."
      },
      {
        "id": "7",
        "title": "The Milkmaid",
        "artist": "Johannes Vermeer",
        "imageUrl":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/Vermeer%2C_Johannes_-_Woman_reading_a_letter_-_ca._1662-1663.jpg/1920px-Vermeer%2C_Johannes_-_Woman_reading_a_letter_-_ca._1662-1663.jpg",
        "type": "Permanent Exhibition",
        "description":
            "The Milkmaid is a quintessential example of Johannes Vermeer's extraordinary talent for capturing everyday moments with elegance and reverence. Painted around 1658, this masterpiece depicts a young woman meticulously pouring milk in a serene domestic setting. Vermeer's use of light and color transforms this humble scene into a celebration of quiet diligence and beauty.\n\nThe intricate details in the painting, from the textured bread to the subtle reflections on the milk jug, highlight Vermeer's meticulous observation and technical precision. The warm, glowing palette enhances the tranquil atmosphere, drawing the viewer into the world of 17th-century Dutch life. The play of light on the milkmaid's face and hands further emphasizes her concentration and dedication to her task.\n\nRecently restored, The Milkmaid has revealed even more about Vermeer's process, including underdrawings and changes he made during its creation. This restoration has deepened our understanding of his artistry, allowing us to appreciate his ability to imbue ordinary moments with profound significance. This permanent exhibition invites visitors to reflect on the timeless themes of simplicity, labor, and grace embodied in this iconic work."
      }
    ];

    return rawData.map((data) => Artwork.fromMap(data)).toList();
  }

  // in the future, this method will fetch data from an API
  Future<List<Artwork>> getAllArtworks() async {
    final popularArtworks = await getPopularArtworks();
    final whatsNewArtworks = await getWhatsNewArtworks();

    return [...popularArtworks, ...whatsNewArtworks];
  }

  // in the future, this method will fetch data from an API
  Future<Artwork?> getArtworkById(String id) async {
    try {
      final artworks = await getAllArtworks();
      return artworks.firstWhere((artwork) => artwork.id == id);
    } catch (e) {
      return null;
    }
  }
}
