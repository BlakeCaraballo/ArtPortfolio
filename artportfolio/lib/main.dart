import 'package:flutter/material.dart';
import './screens/home_screen.dart';

void main() {
  runApp(ArtfolioApp());
}

class ArtfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artfolio',
      theme: ThemeData(
        primaryColor: Color(0xFF344955), // Primary color for app bar
        scaffoldBackgroundColor: Color(0xFF35374B), // Background color for screens
        textTheme: TextTheme(
          // Text styles for app-wide use
          bodyText1: TextStyle(color: Colors.white), // Example
        ),
      ),
      home: HomeScreen(),
    );
  }
}
