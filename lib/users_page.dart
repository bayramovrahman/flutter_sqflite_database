// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sqflite_database/database/sqflite_database_helper.dart';
import 'package:sqflite_database/models/user_model.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // Just emtpy column

  final SqfliteDatabaseHelper _databaseHelper = SqfliteDatabaseHelper();

  Future<List<UserModel>> _fetchUsers() async {
    return await _databaseHelper.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Users'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error occurred: ${snapshot.error}',
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'There are no registered users',
              ),
            );
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text("${user.name} ${user.lastname}"),
                  subtitle: Text(user.email.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete User'),
                          content: const Text('Are you sure you want to delete this user?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirm ?? false) {
                        await _databaseHelper.deleteUserById(id: user.id!);
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${user.name} has been deleted.')),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Just emtpy column
}
