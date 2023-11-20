import 'dart:convert';

import 'package:httpandsqlite/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    "INSERT INTO Produto(id, nome, preco) VALUES(1,'produto 1', 10.0)",
    "INSERT INTO Produto(id, nome, preco) VALUES(2,'produto 2', 15.0)",
    "INSERT INTO Produto(id, nome, preco) VALUES(3,'produto 3', 20.0)",
    "INSERT INTO Produto(id, nome, preco) VALUES(4,'produto 4', 25.0)",
    "INSERT INTO Produto(id, nome, preco) VALUES(5,'produto 5', 30.0)",
    "INSERT INTO Produto(id, nome, preco) VALUES(6,'produto 6', 35.0)",
    "INSERT INTO Produto(id, nome, preco) VALUES(7,'produto 7', 40.0)",
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
        await db.execute(
          'CREATE TABLE Produto(id INTEGER PRIMARY KEY, nome TEXT, preco REAL)',
        );
        for (var element in inserts) {
          await db.execute(element);
        }
        await db.execute(
          'CREATE TABLE UsuarioProduto(usuarioId INTEGER, produtoId INTEGER, quantidade INTEGER, '
          'FOREIGN KEY (usuarioId) REFERENCES Usuario(id), '
          'FOREIGN KEY (produtoId) REFERENCES Produto(id), '
          'PRIMARY KEY (usuarioId, produtoId))',
        );
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
    final List<Map<String, dynamic>> maps = await _database.query('Produto');
    return List.generate(maps.length, (i) {
      return Produto(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        preco: maps[i]['preco'],
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
