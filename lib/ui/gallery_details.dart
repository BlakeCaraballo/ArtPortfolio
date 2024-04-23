part of "gallery.dart";

class GalleryDetails extends StatefulWidget {
  const GalleryDetails({Key? key, required this.artworkId}) : super(key: key);

  final String artworkId;

  @override
  State<GalleryDetails> createState() => _GalleryDetailsState();
}

class _GalleryDetailsState extends State<GalleryDetails> {
  late Artwork artwork;
  late AppProvider appProvider;
  Artist? artist;
  TextEditingController commentController = TextEditingController();
  bool liked = false;
  bool disliked = false;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    artwork = appProvider.artworks
        .firstWhere((element) => element.id == widget.artworkId);

    for (var user in appProvider.artist) {
      if (user.uid == artwork.artistId) {
        artist = user;
        break;
      }
    }

    // Check if the user has liked or disliked the artwork
    liked = artwork.likedByUsers.contains(appProvider.user?.uid);
    disliked = artwork.dislikedByUsers.contains(appProvider.user?.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artwork Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              artwork.title.capitalize,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 10.0),
            if (artist != null)
              Text(
                'Artist: ${artist!.firstName} ${artist!.lastName}',
                style: const TextStyle(fontSize: 16.0),
              ),
            const SizedBox(height: 20.0),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10.0),
            Text(
              artwork.description,
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Images',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10.0),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: artwork.images.length,
              itemBuilder: (context, index) {
                return Image.network(artwork.images[index]);
              },
            ),
            const SizedBox(height: 20.0),
            Text(
              'Comments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: artwork.comments.length,
              itemBuilder: (context, index) {
                final comment = artwork.comments[index];
                return ListTile(
                  title: Text(comment.senderName),
                  subtitle: Text(comment.text),
                );
              },
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      setState(
                        () {
                          artwork.comments.add(Comment(
                            senderName:
                                "${appProvider.user?.firstName.capitalize} ${appProvider.user?.lastName.capitalize}",
                            createdAt: DateTime.now(),
                            text: commentController.text,
                          ));
                          commentController.clear();
                        },
                      );
                    }
                    appProvider.updateArtwork(artwork: artwork);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up,
                      color: liked ? Theme.of(context).primaryColor : null),
                  onPressed: () {
                    setState(() {
                      if (liked) {
                        // If already liked, remove like
                        artwork.likedByUsers.remove(appProvider.user?.uid);
                        liked = false;
                      } else {
                        // If not liked, add like and remove dislike
                        artwork.likedByUsers.add(appProvider.user!.uid);
                        artwork.dislikedByUsers.remove(appProvider.user?.uid);
                        liked = true;
                        disliked = false;
                      }
                      appProvider.updateArtwork(artwork: artwork);
                    });
                  },
                ),
                Text('${artwork.likes}'),
                IconButton(
                  icon: Icon(Icons.thumb_down,
                      color: disliked ? Theme.of(context).primaryColor : null),
                  onPressed: () {
                    setState(() {
                      if (disliked) {
                        // If already disliked, remove dislike
                        artwork.dislikedByUsers.remove(appProvider.user?.uid);
                        disliked = false;
                      } else {
                        // If not disliked, add dislike and remove like
                        artwork.dislikedByUsers.add(appProvider.user!.uid);
                        artwork.likedByUsers.remove(appProvider.user!.uid);
                        disliked = true;
                        liked = false;
                      }
                    });
                    appProvider.updateArtwork(artwork: artwork);
                  },
                ),
                Text('${artwork.dislikes}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
