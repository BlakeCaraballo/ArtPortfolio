// ignore_for_file: use_build_context_synchronously

import 'package:art_portfolio/providers/provider.dart';
import 'package:art_portfolio/ui/add_artwork.dart';
import 'package:art_portfolio/ui/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:art_portfolio/route_names.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final artist = appProvider.user;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: const AppBottomNavigation(selectedIndex: 3),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        forceMaterialTransparency: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (artist != null)
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
                      "${artist.firstName} ${artist.lastName}",
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
              padding: const EdgeInsets.all(6.0),
              child: ListView(
                children: [
                  ListTile(
                    leading:
                        Icon(Icons.edit, color: Theme.of(context).primaryColor),
                    title: const Text('Profile Update'),
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRouteNames.profile);
                    },
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor),
                  ),
                  ListTile(
                    leading: Icon(Icons.person,
                        color: Theme.of(context).primaryColor),
                    title: const Text('My Profile'),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          AppRouteNames.artistProfile,
                          arguments: appProvider.user?.uid);
                    },
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.lock, color: Theme.of(context).primaryColor),
                    title: const Text('Change Password'),
                    onTap: () {
                      _openChangePasswordBottomSheet(context);
                    },
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor),
                  ),
                  ListTile(
                    leading: Icon(Icons.photo,
                        color: Theme.of(context).primaryColor),
                    title: const Text('My Artworks'),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouteNames.artworks,
                        arguments: {"artistId": appProvider.user!.uid},
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor),
                  ),
                  ListTile(
                    leading: Icon(Icons.create,
                        color: Theme.of(context).primaryColor),
                    title: const Text('Add Artwork'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddArtworkPage(),
                        ),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout,
                        color: Theme.of(context).primaryColor),
                    title: const Text('Logout'),
                    onTap: () {
                      _logout(context);
                    },
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, AppRouteNames.login);
  }

  void _openChangePasswordBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: ChangePasswordForm(),
        );
      },
    );
  }
}

class ChangePasswordForm extends StatelessWidget {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Change Password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _currentPasswordController,
            decoration: const InputDecoration(
              hintText: 'Current Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _newPasswordController,
            decoration: const InputDecoration(
              hintText: 'New Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _changePassword(context);
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _changePassword(BuildContext context) {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    final provider = Provider.of<AppProvider>(context, listen: false);

    provider
        .changePassword(
            currentPassword: currentPassword, newPassword: newPassword)
        .then((value) {
      if (value) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.error,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        );
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Password Changed Successfully",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
        );
      }
    });
  }
}
