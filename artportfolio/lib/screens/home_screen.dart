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
import '../artwork_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize Firebase Authentication

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
              icon: Icon(Icons.logout), // Change icon to Logout
              onPressed: () async {
                // Logout functionality
                await _auth.signOut(); // Sign out from Firebase
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              color: Colors.white, // Set button color to white
            ),
          ),
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
              color: Colors.white, // Set button color to white
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFF35374B),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        children: [
          _buildSectionTitle('Featured Artworks'),
          _buildFeaturedArtworks(context),
          _buildSectionTitle('Artist Highlights'),
          _buildArtistHighlights(context),
          _buildSectionTitle('Categories'),
          _buildCategories(),
          SizedBox(height: 50.0,)
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

Widget _buildFeaturedArtworks(BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Navigate to the FeaturedArtworksScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeaturedArtworksScreen()),
      );
    },
    child: Container(
      height: 200.0, // Adjust the height as needed
      width: double.infinity, // Allow the container to fill the width
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Color(0xFF50727B),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          'assets/images/picaso2.jpg', // Replace with your featured artwork image
          fit: BoxFit.cover,
        ),
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
        fit: BoxFit.fitHeight,
      ),
    ),
  );
}


  


  Widget _buildArtistHighlights(BuildContext context) {
  return Container(
    height: 300.0,
    width: 200.0,
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
          width: 300.0,
          height: 250.0, // Set maximum height
          child: Image.asset(
            artist.photoPath,
            fit: BoxFit.cover // Adjust the fit here
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

class FeaturedArtworksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Featured Artworks'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: artworks.length, // Assuming 'artworks' contains all artworks
        itemBuilder: (context, index) {
          final Artwork artwork = artworks[index];

          return GestureDetector(
            onTap: () {
              // Navigate to ArtworkDetailsScreen (assuming it exists)
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

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
