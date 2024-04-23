import 'package:art_portfolio/firebase_options.dart';
import 'package:art_portfolio/providers/provider.dart';
import 'package:art_portfolio/route_names.dart';
import 'package:art_portfolio/ui/artist_profile.dart';
import 'package:art_portfolio/ui/artists.dart';
import 'package:art_portfolio/ui/gallery.dart';
import 'package:art_portfolio/ui/home.dart';
import 'package:art_portfolio/ui/signin.dart';
import 'package:art_portfolio/ui/profile_update.dart';
import 'package:art_portfolio/ui/signup.dart';
import 'package:art_portfolio/ui/settings.dart';
import 'package:art_portfolio/ui/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Art Portfolio',
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
          ),
          colorScheme: const ColorScheme.light(
            primary: Color(0xffbc004b),
          ),
          brightness: Brightness.light,
        ),
        initialRoute: AppRouteNames.splash,
        debugShowCheckedModeBanner: false,
        routes: {
          AppRouteNames.splash: (context) => const SplashScreen(),
          AppRouteNames.login: (context) => const SignIn(),
          AppRouteNames.register: (context) => const SignUp(),
          AppRouteNames.profile: (context) => const ProfilePage(),
          AppRouteNames.settings: (context) => const SettingsScreen(),
          AppRouteNames.home: (context) => const HomePage(),
          AppRouteNames.artists: (context) => const ArtistsScreen(),
          AppRouteNames.artworks: (context) => const Gallery(),
          AppRouteNames.artistProfile: (context) => const ArtistProfile(),
        },
      ),
    );
  }
}
