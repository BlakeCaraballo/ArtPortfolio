class Artist {
  final String email;
  final String firstName;
  final String lastName;
  final DateTime createdAt;
  final DateTime? dob;
  final String uid;
  final String? profileImage;
  final String? bio;

  Artist({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    this.profileImage,
    required this.uid,
    this.dob,
    this.bio,
  });

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      profileImage: map["profileImage"],
      email: map['email'] ?? '',
      uid: map["uid"],
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      dob: map['dob'] != null ? DateTime.parse(map['dob']) : null,
      bio: map['bio'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'createdAt': createdAt.toIso8601String(),
      'dob': dob?.toIso8601String(),
      'uid': uid,
      'profileImage': profileImage,
      'bio': bio,
    };
  }

  Artist copyWith({
    String? email,
    String? firstName,
    String? lastName,
    DateTime? createdAt,
    DateTime? dob,
    String? uid,
    String? profileImage,
    String? bio,
  }) {
    return Artist(
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      createdAt: createdAt ?? this.createdAt,
      dob: dob ?? this.dob,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
    );
  }
}

class Category {
  final String name;
  final String icon;

  Category({required this.name, required this.icon});
}
