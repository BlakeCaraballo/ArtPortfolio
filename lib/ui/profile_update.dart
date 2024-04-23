import 'package:art_portfolio/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Update'),
        actions: [],
      ),
      body: Consumer<AppProvider>(builder: (context, provider, _) {
        final user = provider.user;
        if (user == null) {
          return const Center(
            child: Text("Loading..."),
          );
        }
        _firstNameController.text = user.firstName;
        _lastNameController.text = user.lastName;
        _bio.text = user.bio ?? "";
        _dobController.text =
            user.dob != null ? _formatDateTime(user.dob!) : '';

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormField(
                  'First Name',
                  _firstNameController,
                ),
                const SizedBox(height: 16.0),
                _buildFormField(
                  'Last Name',
                  _lastNameController,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      _dobController.text = _formatDateTime(date);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildFormField('Bio', _bio, minLines: 3),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                    backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).primaryColor),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller,
      {bool enabled = false, TextInputType? keyboardType, int? minLines}) {
    return TextFormField(
      minLines: minLines ?? 1,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      readOnly: enabled,
      keyboardType: keyboardType,
      maxLines: 5,
    );
  }

  void _submit() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final updatedUser = provider.user!.copyWith(
      bio: _bio.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      dob: _dobController.text.isEmpty
          ? null
          : DateTime.parse(_dobController.text),
    );
    provider.updateProfile(updatedUser).then((value) {
      if (value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.error,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Profile Updated Successfully",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _bio.dispose();
    super.dispose();
  }
}

String _formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('MMMM d, yyyy');
  return formatter.format(dateTime);
}
