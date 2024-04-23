import 'package:art_portfolio/route_names.dart';
import 'package:art_portfolio/ui/bottom_navigation.dart';
import 'package:art_portfolio/ui/extentions.dart';
import 'package:art_portfolio/ui/gallery.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:art_portfolio/providers/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      bottomNavigationBar: const AppBottomNavigation(selectedIndex: 0),
      appBar: AppBar(
        title: const Text('Art Portfolio'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Categories section
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: appProvider.categories.length,
                itemBuilder: (context, index) {
                  final category = appProvider.categories[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to artworks page with selected category
                      Navigator.pushNamed(context, AppRouteNames.artworks,
                          arguments: {"category": category.name});
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          
                          child: Image.asset(
                            category.icon,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Text(category.name),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Featured Artworks section
              Text(
                'Featured Artworks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: appProvider.artworks.length > 8
                    ? 8
                    : appProvider.artworks.length,
                itemBuilder: (context, index) {
                  final artwork = appProvider.artworks[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GalleryDetails(artworkId: artwork.id!),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(artwork.images.first),
                      ),
                      title: Text(artwork.title.capitalize, style: Theme.of(context).textTheme.titleMedium,),
                      subtitle: Text(artwork.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.thumb_up),
                          Text(artwork.likes.toString()),
                          const SizedBox(width: 10),
                          const Icon(Icons.thumb_down),
                          Text(artwork.dislikes.toString()),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Featured Artists section
              Text(
                'Featured Artists',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              // List the first 5 featured artists
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: appProvider.artist.length > 20
                    ? 20
                    : appProvider.artist.length,
                itemBuilder: (context, index) {
                  final artist = appProvider.artist[index];
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
                        'Member since ${formatDateTime(artist.createdAt)}'),
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
            ],
          ),
        ),
      ),
    );
  }
}

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat.yMMMMd().add_jm();
  return formatter.format(dateTime);
}
