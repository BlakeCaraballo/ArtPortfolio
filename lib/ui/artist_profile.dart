import 'package:art_portfolio/models/artist.dart';
import 'package:art_portfolio/route_names.dart';
import 'package:art_portfolio/ui/extentions.dart';
import 'package:art_portfolio/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:art_portfolio/providers/provider.dart';

class ArtistProfile extends StatelessWidget {
  const ArtistProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final String artistId =
        ModalRoute.of(context)!.settings.arguments as String? ?? "";
    final appProvider = Provider.of<AppProvider>(context);
    Artist? artist;
    for (var user in appProvider.artist) {
      if (user.uid == artistId) {
        artist = user;
        break;
      }
    }
    if (artist == null) {
      // Handle artist not found
      return const Center(child: Text('Artist not found'));
    }


    return Scaffold(
       extendBody: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    artist.profileImage != null
                        ? CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(artist.profileImage!),
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person),
                          ),
                    const SizedBox(height: 20),
                    Text(
                      "${artist.firstName.capitalize} ${artist.lastName.capitalize}",
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(
                    15,
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: <Widget>[
                              ListTile(
                              leading: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                                size: 36.0,
                              ),
                              title: const Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(artist.email),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.calendar_month_outlined,
                                color: Theme.of(context).primaryColor,
                                size: 36.0,
                              ),
                              title: const Text(
                                'Joined',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Joined, ${formatDateTime(artist.createdAt)}',
                              ),
                            ),
                            if (artist.bio != null)
                              ListTile(
                                leading: Icon(
                                  Icons.info,
                                  color: Theme.of(context).primaryColor,
                                  size: 36.0,
                                ),
                                title: const Text(
                                  'Bio',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(artist.bio ?? ""),
                              ),
                            ListTile(
                              leading: Icon(
                                Icons.browse_gallery,
                                color: Theme.of(context).primaryColor,
                                size: 36.0,
                              ),
                              title: const Text(
                                'Artworks',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                
                              ),
                              subtitle: const Text("View Artworks"),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRouteNames.artworks,
                                  arguments: {"artistId": artist!.uid},
                                );
                              },
                            ),
                            if (artist.dob != null)
                              ListTile(
                                leading: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 36.0,
                                ),
                                title: const Text(
                                  'Born',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Born, ${formatDateTime(artist.dob!)}',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
