import 'artist_model.dart';

final List<Artist> artists = [
  Artist(
    name: 'Pablo Picasso',
    biography:
        'Pablo Picasso was a Spanish painter, sculptor, printmaker, ceramicist and theatre designer who spent most of his adult life in France.',
    photoPath: 'assets/images/picaso_self.jpg',
    gallery: [
      'assets/images/picaso1.jpg',
      'assets/images/picaso2.jpg',
      'assets/images/picaso3.png',
    ],
    category: "paintings"
  ),
  Artist(
    name: 'Vincent van Gogh',
    biography:
        'Vincent Willem van Gogh was a Dutch Post-Impressionist painter who is among the most famous and influential figures in the history of Western art.',
    photoPath: 'assets/images/vangogh1.jpg',
    gallery: [
      'assets/images/vangogh1.jpg',
      'assets/images/vangogh2.jpg',
      'assets/images/vangogh3.jpg',
    ],
    category: "paintings"
  ),
  Artist(
    name: 'Rembrandt',
    biography:
        'Rembrandt van Rijn was a Dutch painter and printmaker who lived during the Dutch Golden Age in the 17th century. Born on July 15, 1606, in Leiden, Netherlands, Rembrandt is widely regarded as one of the greatest artists in history and is known for his masterful use of light and shadow, as well as his ability to capture emotion and humanity in his works.',
    photoPath: 'assets/images/rembrant_self.jpg',
    gallery: [
      'assets/images/rembrant1.jpg',
      'assets/images/rembrant2.jpg',
      'assets/images/rembrant3.jpg',
    ],
    category: "paintings"
  ),
  // Add more artists as needed
];
