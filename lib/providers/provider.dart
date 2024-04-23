import 'dart:io';

import 'package:art_portfolio/models/artist.dart';
import 'package:art_portfolio/models/artwork.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AppProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uuid = Uuid();

  Artist? _user;
  bool _isLoading = false;
  String _error = '';
  List<Artwork> _artworks = [];
  List<Artist> _artists = [];

  Artist? get user => _user;
  List<Category> get categories => [
        Category(name: 'Abstract Art', icon: "assets/icons/abstract.jpg"),
        Category(name: 'Landscape', icon: "assets/icons/landscape.jpg"),
        Category(name: 'Portrait Art', icon: "assets/icons/portrait.jpg"),
        Category(name: 'Still Life', icon: "assets/icons/still_life.jpg"),
        Category(name: 'Street Art', icon: "assets/icons/street_art.jpg"),
      ];
  bool get isLoading => _isLoading;
  List<Artwork> get artworks => _artworks;
  List<Artist> get artist => _artists;
  String get error => _error;

  AppProvider() {
    _initMessageListener();
  }
  void _initMessageListener() {
    _firestore
        .collection('artworks')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      _artworks = List<Artwork>.from(
          snapshot.docs.map((doc) => Artwork.fromJson(doc.data() as dynamic)));
      notifyListeners();
    });
    _firestore.collection("profiles").snapshots().listen(
      (event) {
        _artists = List<Artist>.from(
          event.docs.map((doc) => Artist.fromMap(doc.data() as dynamic)),
        );
      },
    );

    loadArtworks();
    loadArtists();
  }

  // Profile update
  Future<Artist?> updateProfile(Artist user) async {
    Artist? updatedUser;
    try {
      _isLoading = true;
      notifyListeners();
      await _firestore
          .collection('profiles')
          .doc(_user!.uid)
          .update(user.toMap());
      _user = user;
      updatedUser = user;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return updatedUser;
  }

  Future<bool> createArtwork({
    required String title,
    required List<String> categories,
    required List<File> files,
    required String description,
  }) async {
    bool success = false;
    try {
      _isLoading = true;
      notifyListeners();
      List<String> images = await uploadImages(files);
      String id = uuid.v4();
      await _firestore.collection('artworks').doc(id).set(
            Artwork(
              id: id,
              artistId: _user!.uid,
              categories: categories,
              description: description,
              title: title,
              images: images,
              createdAt: DateTime.now(),
            ).toJson(),
          );
      success = true;
    } catch (e) {
      _error = 'Failed to create artwork: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<bool> updateArtwork({
    required Artwork artwork,
    List<File>? files,
  }) async {
    bool success = false;
    try {
      _isLoading = true;
      notifyListeners();
      List<String> images = artwork.images;
      if (files != null) {
        for (var url in await uploadImages(files)) {
          images.add(url);
        }
      }
      await _firestore.collection('artworks').doc(artwork.id).update(
            artwork.copyWith(images: images).toJson(),
          );
      success = true;
    } catch (e) {
      _error = 'Failed to update artwork: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<void> loadArtworks() async {
    try {
      _isLoading = true;
      notifyListeners();
      QuerySnapshot snapshot = await _firestore.collection('artworks').get();

      _artworks = List<Artwork>.from(
        snapshot.docs.map((doc) => Artwork.fromJson(doc.data() as dynamic)),
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Artist?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        _user = Artist(
          uid: firebaseUser.uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          createdAt: DateTime.now(),
        );
        await _firestore
            .collection('profiles')
            .doc(firebaseUser.uid)
            .set(_user!.toMap());
      }
    } on FirebaseAuthException catch (e) {
      _error = e.code.replaceAll("-", " ");
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return user;
  }

  Future<Artist?> login({
    required String email,
    required String password,
  }) async {
    Artist? updatedUser;
    try {
      _isLoading = true;
      notifyListeners();
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('profiles').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          _user = Artist.fromMap(userData);
          updatedUser = _user;
        }
      }
    } on FirebaseAuthException catch (e) {
      _error = e.code.replaceAll("-", " ");
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return updatedUser;
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    bool success = false;
    try {
      _isLoading = true;
      notifyListeners();

      AuthCredential credential = EmailAuthProvider.credential(
        email: _user!.email,
        password: currentPassword,
      );
      await _auth.currentUser!.reauthenticateWithCredential(credential);

      await _auth.currentUser!.updatePassword(newPassword);

      success = true;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? e.toString();
    } catch (e) {
      _error = 'An unexpected error occurred.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<List<String>> uploadImages(List<File> files) async {
    List<String> imageUrls = [];
    try {
      for (File file in files) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref =
            FirebaseStorage.instance.ref().child('images/$fileName');
        await ref.putFile(file);
        String url = await ref.getDownloadURL();
        imageUrls.add(url);
      }
    } catch (e) {
      _error = 'Failed to upload images: $e';
    }
    return imageUrls;
  }

  Future<List<Artist>> loadArtists() async {
    try {
      _isLoading = true;
      notifyListeners();
      QuerySnapshot snapshot = await _firestore.collection('profiles').get();
      _artists = List<Artist>.from(
        snapshot.docs.map((doc) => Artist.fromMap(doc.data() as dynamic)),
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return _artists;
  }
}
