// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sqflite_database/database/sqflite_database_helper.dart';
import 'package:sqflite_database/models/user_model.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _countryController;

  final SqfliteDatabaseHelper _databaseHelper = SqfliteDatabaseHelper();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _lastnameController = TextEditingController(text: widget.user.lastname);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    _countryController = TextEditingController(text: widget.user.country);
  }

  Future<void> _saveProfile() async {
    final updatedUser = UserModel(
      id: widget.user.id,
      username: widget.user.username,
      password: widget.user.password,
      name: _nameController.text,
      lastname: _lastnameController.text,
      birthdayDate: widget.user.birthdayDate,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      country: _countryController.text,
      createdAt: widget.user.createdAt,
    );

    await _databaseHelper.updateUserById(user: updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );

    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "First Name"),
            ),
            TextField(
              controller: _lastnameController,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: "Country"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _countryController.dispose();
    super.dispose();
  }
}
