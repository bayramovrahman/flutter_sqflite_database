import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_database/models/user_model.dart';
import 'package:sqflite_database/constants/database_constants.dart';

class SqfliteDatabaseHelper {
  // Just empty column

  static const String _userTableName = DatabaseConstants.userTableName;
  static const String _databaseName = DatabaseConstants.databaseName;
  static Database? _database;

  Future<Database> initDatabase() async {
    if (_database != null) {
      return _database!;
    }

    String dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE $_userTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            name TEXT NOT NULL,
            lastname TEXT NOT NULL,
            birthday_date TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            phone TEXT NOT NULL UNIQUE,
            address TEXT NOT NULL,
            country TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<int> insertUser({required UserModel user}) async {
    final db = await initDatabase();
    return await db.insert(_userTableName, user.toMap());
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> userMaps = await db.query(_userTableName);
    return userMaps.map((map) => UserModel.fromMap(map)).toList();
  }

  Future<int> updateUserById({required UserModel user}) async {
    final db = await initDatabase();
    return await db.update(
      _userTableName,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUserById({required int id}) async {
    final db = await initDatabase();
    return await db.delete(_userTableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<UserModel?> getUserByUsername({required String username}) async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> result = await db.query(
      _userTableName,
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<void> removeDatabase() async {
    try {
      String dbPath = await getDatabasesPath();
      String myDbPath = join(dbPath, _databaseName);
      bool dbExists = await databaseExists(myDbPath);
      if (dbExists) {
        await deleteDatabase(myDbPath);
        debugPrint("Database deleted: $myDbPath");
      } else {
        debugPrint("No database found at: $myDbPath");
      }
    } catch (e) {
      debugPrint("Error deleting database: $e");
    }
  }

  Future<void> closeDatabase() async {
    final db = await initDatabase();
    await db.close();
    debugPrint("The database connection was closed.");
  }

  // Just empty column
}
