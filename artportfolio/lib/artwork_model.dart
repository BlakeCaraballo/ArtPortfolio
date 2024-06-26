class Artwork {
  final String name;
  final String imagePath;
  final String artistName; // Add artist name
  final String category; // Add category

  Artwork({required this.name, required this.imagePath, required this.artistName, required this.category});
}

final List<Artwork> artworks = [
  Artwork(
    name: 'Girl Before a Mirror',
    imagePath: 'assets/images/picaso1.jpg',
    artistName: 'Picasso',
    category: 'Painting',
  ),
    Artwork(
    name: 'The Weeping Woman',
    imagePath: 'assets/images/picaso2.jpg',
    artistName: 'Picasso',
    category: 'Painting',
  ),
    Artwork(
    name: 'Weird Guy',
    imagePath: 'assets/images/picaso3.png',
    artistName: 'Picasso',
    category: 'Painting',
  ),
  Artwork(
    name: 'Artwork 1',
    imagePath: 'assets/images/vangogh1.jpg',
    artistName: 'Vincent van Gogh',
    category: 'Painting',
  ),
   Artwork(
    name: 'Artwork 2',
    imagePath: 'assets/images/vangogh2.jpg',
    artistName: 'Vincent van Gogh',
    category: 'Painting',
  ),
   Artwork(
    name: 'Artwork 3',
    imagePath: 'assets/images/vangogh3.jpg',
    artistName: 'Vincent van Gogh',
    category: 'Painting',
  ),
   Artwork(
    name: 'Artwork 4',
    imagePath: 'assets/images/rembrant1.jpg',
    artistName: 'Rembrandt',
    category: 'Painting',
  ),
   Artwork(
    name: 'Artwork 4',
    imagePath: 'assets/images/rembrant2.jpg',
    artistName: 'Rembrandt',
    category: 'Painting',
  ),
   Artwork(
    name: 'Artwork 4',
    imagePath: 'assets/images/rembrant3.jpg',
    artistName: 'Rembrandt',
    category: 'Painting',
  ),
   Artwork(
    name: 'YellowStone',
    imagePath: 'assets/images/adams1.jpg',
    artistName: 'Adams',
    category: 'Photography',
  ),
   Artwork(
    name: 'Photo 2',
    imagePath: 'assets/images/adams2.jpg',
    artistName: 'Adams',
    category: 'Photography',
  ),
   Artwork(
    name: 'Photo 3',
    imagePath: 'assets/images/adams3.jpg',
    artistName: 'Adams',
    category: 'Photography',
  ),
   Artwork(
    name: 'Photo 4',
    imagePath: 'assets/images/mccurry1.jpg',
    artistName: 'McCurry',
    category: 'Photography',
  ),
   Artwork(
    name: 'Photo 5',
    imagePath: 'assets/images/mccurry2.jpg',
    artistName: 'McCurry',
    category: 'Photography',
  ),
   Artwork(
    name: 'Photo 6',
    imagePath: 'assets/images/mccurry3.jpg',
    artistName: 'McCurry',
    category: 'Photography',
  ),
    Artwork(
    name: 'Bird Ceramic',
    imagePath: 'assets/images/pablo_ceramic.jpg',
    artistName: 'picaso',
    category: 'Sculpture',
  ),
    Artwork(
    name: 'Fish Teapot',
    imagePath: 'assets/images/pablo_ceramic2.jpg',
    artistName: 'picaso',
    category: 'Sculpture',
  ),
    Artwork(
    name: 'Photo 6',
    imagePath: 'assets/images/pablo_ceramic3.jpg',
    artistName: 'picaso',
    category: 'Sculpture',
  ),
  // Add more artworks as needed
];