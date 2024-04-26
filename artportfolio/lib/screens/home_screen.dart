import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../artist_model.dart'; // Import the Artist model
import 'artist_screen.dart'; // Import the ArtistScreen
import '../artist_data.dart';
import '../category_data.dart';
import './category_gallery.dart';
import 'login_screen.dart'; // Import the LoginScreen
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artfolio'),
        centerTitle: true,
        backgroundColor: Color(0xFF344955),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Adjust the padding here
            child: IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFF35374B),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        children: [
          _buildSectionTitle('Featured Artworks'),
          _buildFeaturedArtworks(),
          _buildSectionTitle('Artist Highlights'),
          _buildArtistHighlights(context),
          _buildSectionTitle('Categories'),
          _buildCategories(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

 Widget _buildFeaturedArtworks() {
  return Container(
    height: 200.0,
    margin: EdgeInsets.symmetric(horizontal: 16.0),
    decoration: BoxDecoration(
      color: Color(0xFF50727B),
      borderRadius: BorderRadius.circular(10.0), // Rounded corners
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildArtworkItem('assets/images/picaso1.jpg'),
          _buildArtworkItem('assets/images/picaso2.jpg'),
          _buildArtworkItem('assets/images/picaso3.png'),

        ],
      ),
    ),
  );
}

  Widget _buildArtworkItem(String imagePath) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          imagePath,
          width: 150.0,
          height: 150.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  


  Widget _buildArtistHighlights(BuildContext context) {
  return Container(
    height: 200.0,
    width: 100.0,
    margin: EdgeInsets.symmetric(horizontal: 16.0),
    decoration: BoxDecoration(
      color: Color(0xFF50727B),
      borderRadius: BorderRadius.circular(10.0), // Rounded corners
    ),
    child: _buildArtistItem(context, artists[0]), // Assuming you want to display only the first artist
  );
}

  Widget _buildArtistItem(BuildContext context, Artist artist) {
  return Container(
    margin: EdgeInsets.all(8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtistScreen(artist: artist),
            ),
          );
        },
        child: Container(
          width: 200.0,
          height: 150.0, // Set maximum height
          child: Image.asset(
            artist.photoPath,
            fit: BoxFit.scaleDown, // Adjust the fit here
          ),
        ),
      ),
    ),
  );
}

  Widget _buildCategories() {
    double imageSize = 200.0; // Adjust the size of the images as needed
    double containerHeight = 124.0; // Initial height of the container
    int crossAxisCount = 3; // Number of items per row

    // Calculate the total height required for the images and spacing
    double totalHeight = (imageSize + 8.0) * (categories.length / crossAxisCount).ceil();

    // If the total height required for the images is less than the initial container height,
    // set the container height to the total height, otherwise, keep the initial height
    containerHeight = totalHeight < containerHeight ? totalHeight : containerHeight;

    return Container(
      height: containerHeight,
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Color(0xFF50727B),
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryGallery(category: categories[index].name),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(categories[index].imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  categories[index].name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
