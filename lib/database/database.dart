import 'dart:convert';

import 'package:httpandsqlite/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import '../model/produto.dart';

class DataBase {
  late Database _database;

  late List<String> inserts = [
    "INSERT INTO Usuario(id, username, password) VALUES(1,'user1', 'password')",
    "INSERT INTO Usuario(id, username, password) VALUES(2,'user2', 'password')",
    "INSERT INTO Usuario(id, username, password) VALUES(3,'user3', 'password')",
    "INSERT INTO Usuario(id, username, password) VALUES(4,'user4', 'password')",
    "INSERT INTO Usuario(id, username, password) VALUES(5,'user5', 'password')",
    "INSERT INTO Usuario(id, username, password) VALUES(6,'user6', 'password')",
    "INSERT INTO Usuario(id, username, password) VALUES(7,'user7', 'password')",
  ];

  Future<void> openDatabaseConnection() async {
    final String path = join(await getDatabasesPath(), 'database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE Usuario(id INTEGER PRIMARY KEY, username TEXT, password TEXT)',
        );
        for (var element in inserts) {
          await db.execute(element);
        }
      },
    );
  }

  Future<List<User>> getAllUsuarios() async {
    final List<Map<String, dynamic>> maps = await _database.query('Usuario');
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        username: maps[i]['username'],
        password: maps[i]['password'],
      );
    });
  }

  Future<List<Produto>> getAllProdutos() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    List<dynamic> data = [];
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    }
    return List.generate(data.length, (i) {
      return Produto(
        id: data[i]['id'],
        nome: data[i]['title'],
        preco: data[i]['price'],
      );
    });
  }

  Future<User?> getUserByEmail(String username) async {
    List<Map<String, dynamic>> maps = await _database.query(
      'Usuario',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }

    return null;
  }

  Future<List<Produto>> getProdutos(SharedPreferences sharedPreferences) async {
    String? produtosJson = sharedPreferences.getString('produtos');
    if (produtosJson != null && produtosJson.isNotEmpty) {
      List<dynamic> produtosList = jsonDecode(produtosJson);

      // Certifique-se de que cada item na lista é um Map<String, dynamic>
      List<Map<String, dynamic>> produtosMapList =
          produtosList.map((item) => item as Map<String, dynamic>).toList();

      List<Produto> produtos =
          produtosMapList.map((map) => Produto.fromMap(map)).toList();
      return produtos;
    } else {
      return [];
    }
  }
}
