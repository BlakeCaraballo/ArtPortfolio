import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../artist_model.dart';


class GalleryScreen extends StatelessWidget {
  final Artist artist;

  const GalleryScreen({Key? key, required this.artist}) : super(key: key);

 Future<void> _pickImage(BuildContext context) async {
  final picker = ImagePicker();
  try {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Upload the picked image to Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('gallery/${DateTime.now()}.jpg');
      UploadTask uploadTask = ref.putFile(File(pickedFile.path));
      // Handle the upload task completion
      uploadTask.then((res) {
        // Get the download URL of the uploaded image
        res.ref.getDownloadURL().then((url) {
          // Add the URL to the artist's gallery
          artist.gallery.add(url);
          // Update the UI to reflect the changes
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image added to gallery')),
          );
        });
      }).catchError((error) {
        // Handle errors during the upload task
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $error')),
        );
      });
    }
  } catch (e) {
    // Handle errors when picking an image
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error picking image: $e')),
    );
  }
}

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
            child: Image.network(
              artist.gallery[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickImage(context),
        tooltip: 'Add to Gallery',
        child: Icon(Icons.add),
      ),
    );
  }
}