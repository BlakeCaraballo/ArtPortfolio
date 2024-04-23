// ignore_for_file: use_build_context_synchronously

import 'package:art_portfolio/models/artist.dart';
import 'package:art_portfolio/models/artwork.dart';
import 'package:art_portfolio/providers/provider.dart';
import 'package:art_portfolio/route_names.dart';
import 'package:art_portfolio/ui/bottom_navigation.dart';
import 'package:art_portfolio/ui/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:provider/provider.dart';

part 'gallery_details.dart';

class Gallery extends StatelessWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String? selectedArtist = args?['artistId'];
    final String? selectedCategory = args?['category'];
    final appProvider = Provider.of<AppProvider>(context);
    List<Artwork> filteredArtworks = appProvider.artworks;
    Artist? artist;

    // Apply filtering based on selectedArtist, selectedCategory
    if (selectedArtist != null) {
      filteredArtworks = filteredArtworks
          .where((artwork) => artwork.artistId == selectedArtist)
          .toList();
      artist = appProvider.artist
          .where((element) => element.uid == selectedArtist)
          .firstOrNull;
    }
    if (selectedCategory != null) {
      filteredArtworks = filteredArtworks
          .where((artwork) => artwork.categories.contains(selectedCategory))
          .toList();
    }

    return Scaffold(
      bottomNavigationBar: const AppBottomNavigation(selectedIndex: 1),
      appBar: AppBar(
        title: const Text('Gallery'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final artwork = await showSearch(
                context: context,
                delegate: ArtworkSearchDelegate(),
              );
              if (artwork != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GalleryDetails(artworkId: artwork.id!),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BreadCrumb(

              items: [
                BreadCrumbItem(
                  content: const Text("Artworks",style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRouteNames.artworks),
                ),
                if (selectedCategory != null)
                  BreadCrumbItem(
                    content: Text(
                      selectedCategory.capitalize,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                if (artist != null) ...[
                  BreadCrumbItem(
                    content: const Text(
                      "Artist",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRouteNames.artists),
                  ),
                  BreadCrumbItem(
                    content: Text(
                      "${artist.firstName} ${artist.lastName}",
                    ),
                  ),
                ]
              ],
              divider: const Icon(Icons.chevron_right),
              overflow: const WrapOverflow(
                keepLastDivider: false,
                direction: Axis.horizontal,
              ),
            ),
          ),
        ),
      ),
          filteredArtworks.isEmpty
              ? const Center(
                  child: Text("No artworks found"),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredArtworks.length,
                  itemBuilder: (BuildContext context, int index) {
                    final artwork = filteredArtworks[index];
                    final imageUrl =
                        artwork.images.isNotEmpty ? artwork.images.first : '';
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GalleryDetails(artworkId: artwork.id!),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : const Center(
                                        child: Text('No Image'),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                artwork.title.capitalize,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}





class ArtworkSearchDelegate extends SearchDelegate<Artwork?> {
  ArtworkSearchDelegate();

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
        .artworks
        .where(
          (artwork) =>
              artwork.title.toLowerCase().contains(query.toLowerCase()) ||
              artwork.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = Provider.of<AppProvider>(context)
        .artworks
        .where(
          (artwork) =>
              artwork.title.toLowerCase().contains(query.toLowerCase()) ||
              artwork.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return _buildSearchResults(results);
  }

  Widget _buildSearchResults(List<Artwork> results) {
    if (results.isEmpty) {
      return const ListTile(
        title: Text("No result found"),
      );
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final artwork = results[index];
        return ListTile(
          title: Text(artwork.title),
          subtitle: Text(artwork.description),
          onTap: () {
            close(context, artwork);
          },
        );
      },
    );
  }
}
