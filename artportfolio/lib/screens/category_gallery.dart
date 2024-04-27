import 'package:flutter/material.dart';
import '../artwork_model.dart';

class CategoryGallery extends StatelessWidget {
  final String category;

  const CategoryGallery({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter artworks based on the selected category
    List<Artwork> categoryArtworks = artworks.where((artwork) => artwork.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: categoryArtworks.length,
        itemBuilder: (context, index) {
          final Artwork artwork = categoryArtworks[index]; // Get the current artwork

          return GestureDetector(
            onTap: () {
              // Navigate to a new screen displaying artwork details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtworkDetailsScreen(artwork: artwork),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(artwork.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              // You can customize the child widget as needed
            ),
          );
        },
      ),
    );
  }
}

class ArtworkDetailsScreen extends StatelessWidget {
  final Artwork artwork;

  const ArtworkDetailsScreen({Key? key, required this.artwork}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artwork.name),
      ),
      body: SingleChildScrollView( // Allow scrolling for long content
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the artwork image
            Hero( // Enable hero animation for smooth transition
              tag: artwork.name, // Unique tag for the image
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  artwork.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Display artwork details
            Text(
              'Artist: ${artwork.artistName}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Category: ${artwork.category}',
              style: TextStyle(fontSize: 16.0),
            ),
            // You can add more information about the artwork here
          ],
        ),
      ),
    );
  }
}
