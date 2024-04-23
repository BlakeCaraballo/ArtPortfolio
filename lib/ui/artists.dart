// ignore_for_file: use_build_context_synchronously

import 'package:art_portfolio/models/artist.dart';
import 'package:art_portfolio/providers/provider.dart';
import 'package:art_portfolio/route_names.dart';
import 'package:art_portfolio/ui/bottom_navigation.dart';
import 'package:art_portfolio/ui/extentions.dart';
import 'package:art_portfolio/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistsScreen extends StatelessWidget {
  const ArtistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      bottomNavigationBar: const AppBottomNavigation(selectedIndex: 2),
      appBar: AppBar(
        title: const Text('Artists'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final artist = await showSearch(
                context: context,
                delegate: ArtistSearchDelegate(),
              );
              if (artist != null) {
                Navigator.pushNamed(
                  context,
                  AppRouteNames.artistProfile,
                  arguments: artist.uid,
                );
              }
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: appProvider.artist.length,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          Artist artist = appProvider.artist[index];
          return ListTile(
            leading: artist.profileImage != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(artist.profileImage!),
                  )
                : const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
            title: Text('${artist.firstName.capitalize} ${artist.lastName.capitalize}'),
            subtitle: Text(
              'Member since ${formatDateTime(artist.createdAt)}',
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouteNames.artistProfile,
                arguments: artist.uid,
              );
            },
          );
        },
      ),
    );
  }
}

class ArtistSearchDelegate extends SearchDelegate<Artist?> {
  ArtistSearchDelegate();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = Provider.of<AppProvider>(context)
        .artist
        .where(
          (artist) =>
              artist.firstName.toLowerCase().contains(query.toLowerCase()) ||
              artist.lastName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = Provider.of<AppProvider>(context)
        .artist
        .where(
          (artist) =>
              artist.firstName.toLowerCase().contains(query.toLowerCase()) ||
              artist.lastName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return _buildSearchResults(results);
  }

  Widget _buildSearchResults(List<Artist> results) {
    if (results.isEmpty) {
      return const ListTile(
        title: Text("No result found"),
      );
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final artist = results[index];
        return ListTile(
          leading: artist.profileImage != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(artist.profileImage!),
                )
              : const CircleAvatar(
                  child: Icon(Icons.person),
                ),
          title: Text('${artist.firstName} ${artist.lastName}'),
          subtitle: Text(
            'Member since ${formatDateTime(artist.createdAt)}',
          ),
          onTap: () {
            close(context, artist);
          },
        );
      },
    );
  }
}
