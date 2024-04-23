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
          return GestureDetector(
            onTap: () {
              // Handle artwork tap
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(categoryArtworks[index].imagePath),
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
