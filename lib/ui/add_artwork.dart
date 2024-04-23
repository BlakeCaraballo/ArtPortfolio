// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:art_portfolio/providers/provider.dart';
import 'package:art_portfolio/route_names.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddArtworkPage extends StatefulWidget {
  const AddArtworkPage({Key? key}) : super(key: key);

  @override
  State<AddArtworkPage> createState() => _AddArtworkPageState();
}

class _AddArtworkPageState extends State<AddArtworkPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Store selected categories
  final List<String> _selectedCategories = [];
  List<File> _selectedImages = [];

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Artwork'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Category selection using checkboxes
              Text(
                "Artwork Category",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appProvider.categories.length,
                itemBuilder: (context, index) {
                  final category = appProvider.categories[index];
                  return CheckboxListTile(
                    title: Text(category.name),
                    value: _selectedCategories.contains(category.name),
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value) {
                          _selectedCategories.add(category.name);
                        } else {
                          _selectedCategories.remove(category.name);
                        }
                      });
                    },
                  );
                },
              ),
              Text(
                "Artwork Images",
                style: Theme.of(context).textTheme.titleMedium,
              ),

              _selectedImages.isEmpty
                  ? const SizedBox()
                  : GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: _selectedImages
                          .map((image) => Image.file(File(image.path)))
                          .toList(),
                    ),
              TextButton(
                onPressed: _pickImages,
                child: const Text('Select Images'),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitArtwork(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    setState(() {
     _selectedImages = pickedImages.map((xfile) => File(xfile.path)).toList();
    });
    }

  Future<void> _submitArtwork(BuildContext context) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    if (appProvider.isLoading) {
      return;
    }
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Select at least 1 image",
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Submitting please wait...",
        style: TextStyle(color: Colors.greenAccent),
      ),
    ));
    // Extract input data
    final title = _titleController.text;
    final description = _descriptionController.text;
    final files = _selectedImages;

    // Call the provider method to create artwork
    final created = await appProvider.createArtwork(
      title: title,
      description: description,
      categories: _selectedCategories,
      files: files,
    );
    if (created) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Artwork has been added",
          style: TextStyle(color: Colors.greenAccent),
        ),
      ));
      // Navigate to artworks page with selected category
      Navigator.pushNamed(
        context,
        AppRouteNames.artworks,
        arguments: {"artistId": appProvider.user!.uid},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          appProvider.error,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ));
    }
  }
}
