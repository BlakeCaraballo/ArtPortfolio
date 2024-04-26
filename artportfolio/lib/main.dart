import 'package:flutter/material.dart';
import './screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(ArtfolioApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
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
      home: LoginScreen(),
    );
  }
}
