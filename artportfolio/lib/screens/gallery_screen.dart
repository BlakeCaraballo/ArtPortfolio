import 'package:flutter/material.dart';
import '../artist_model.dart';

class GalleryScreen extends StatelessWidget {
  final Artist artist;

  const GalleryScreen({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${artist.name}\'s Gallery'),
      ),
      body: ListView.builder(
        itemCount: artist.gallery.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              artist.gallery[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}