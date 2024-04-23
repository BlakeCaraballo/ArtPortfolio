class Artwork {
  final String? id;
  final String title;
  final List<String> categories;
  final List<String> images;
  final String description;
  final String artistId;
  final DateTime createdAt;
  // List of user ids who liked the artwork
  final List<String> likedByUsers;
  // List of user ids who disliked the artwork
  final List<String> dislikedByUsers;
  final List<Comment> comments;

  Artwork({
    this.id,
    required this.title,
    required this.categories,
    required this.images,
    required this.description,
    required this.artistId,
    required this.createdAt,
    this.likedByUsers = const [],
    this.dislikedByUsers = const [],
    this.comments = const [],
  });

  // Getters for likes and dislikes count
  int get likes => likedByUsers.length;
  int get dislikes => dislikedByUsers.length;

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'],
      title: json['title'],
      categories: List<String>.from(json['categories']),
      images: List<String>.from(json['images']),
      description: json['description'],
      artistId: json['artistId'],
      createdAt: DateTime.parse(json['createdAt']),
      likedByUsers: List<String>.from(json['likedByUsers'] ?? []),
      dislikedByUsers: List<String>.from(json['dislikedByUsers'] ?? []),
      comments: (json['comments'] ?? [])
          .map<Comment>((c) => Comment.fromJson(c))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'categories': categories,
      'images': images,
      'description': description,
      'artistId': artistId,
      'createdAt': createdAt.toIso8601String(),
      'likedByUsers': likedByUsers,
      'dislikedByUsers': dislikedByUsers,
      'comments': comments.map((c) => c.toJson()).toList(),
    };
  }

  Artwork copyWith({
    String? id,
    String? title,
    List<String>? categories,
    List<String>? images,
    String? description,
    String? artistId,
    DateTime? createdAt,
    List<String>? likedByUsers,
    List<String>? dislikedByUsers,
    List<Comment>? comments,
  }) {
    return Artwork(
      id: id ?? this.id,
      title: title ?? this.title,
      categories: categories ?? this.categories,
      images: images ?? this.images,
      description: description ?? this.description,
      artistId: artistId ?? this.artistId,
      createdAt: createdAt ?? this.createdAt,
      likedByUsers: likedByUsers ?? this.likedByUsers,
      dislikedByUsers: dislikedByUsers ?? this.dislikedByUsers,
      comments: comments ?? this.comments,
    );
  }
}

class Comment {
  final String senderName;
  final String? senderProfileImage;
  final DateTime createdAt;
  final String text;

  Comment({
    required this.senderName,
    this.senderProfileImage,
    required this.createdAt,
    required this.text,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      senderName: json['senderName'],
      senderProfileImage: json['senderProfileImage'],
      createdAt: DateTime.parse(json['createdAt']),
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderName': senderName,
      'senderProfileImage': senderProfileImage,
      'createdAt': createdAt.toIso8601String(),
      'text': text,
    };
  }
}
