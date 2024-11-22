// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sqflite_database/models/user_model.dart';
import 'package:sqflite_database/database/sqflite_database_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Just empty column

  final SqfliteDatabaseHelper _databaseHelper = SqfliteDatabaseHelper();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  DateTime? _selectedBirthday;

  Future<void> _addUser() async {
    if (_usernameController.text.isEmpty || _emailController.text.isEmpty || _selectedBirthday == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    final newUser = UserModel(
      username: _usernameController.text,
      password: _passwordController.text,
      name: _nameController.text,
      lastname: _lastnameController.text,
      birthdayDate: _selectedBirthday!.toIso8601String(), 
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      country: _countryController.text,
      createdAt: DateTime.now(),
    );

    await _databaseHelper.insertUser(user: newUser);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("The user is successfully registered")),
    );

    setState(() {});

    _clearForm();
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Add New User",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: _lastnameController,
                decoration: const InputDecoration(labelText: "Lastname"),
              ),
              GestureDetector(
                onTap: () => _selectBirthday(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                        text: _selectedBirthday == null
                            ? ''
                            : _selectedBirthday!.toLocal().toString().split(' ')[0]),
                    decoration: const InputDecoration(
                      labelText: "Date of birth",
                      hintText: "Select Date",
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "E-mail"),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Adress"),
              ),
              TextField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: "Country"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addUser,
                child: const Text("Add User"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearForm() {
    _usernameController.clear();
    _passwordController.clear();
    _nameController.clear();
    _lastnameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    _countryController.clear();
    setState(() {
      _selectedBirthday = null;
    });
  }

  // Just empty column
}