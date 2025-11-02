import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final newDbPath = join(dbPath, 'universe_new.db');


    return await openDatabase(
      newDbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
        print('✅ Database baru berhasil dibuat: $newDbPath');
      },
    );
  }

  // 🔐 Hash password dengan SHA256
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // Register user baru
  Future<int> registerUser(String username, String email, String password) async {
    final db = await database;
    final hashed = hashPassword(password);

    return await db.insert(
      'users',
      {
        'username': username,
        'email': email,
        'password': hashed,
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // Login user
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final hashed = hashPassword(password);

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashed],
    );

    if (result.isNotEmpty) {
      print('✅ Login berhasil untuk $email');
      return result.first;
    }
    print('❌ Login gagal untuk $email');
    return null;
  }

 
  Future<void> clearUsers() async {
    final db = await database;
    await db.delete('users');
    print('Semua data user telah dihapus');
  }
}
