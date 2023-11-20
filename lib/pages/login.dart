import 'package:flutter/material.dart';
import 'package:httpandsqlite/database/database.dart';
import 'package:httpandsqlite/model/user.dart';
import 'package:httpandsqlite/pages/compras.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _senha = TextEditingController();
  late DataBase _database;

  @override
  void initState() {
    super.initState();
    _initDatabaseAndLoadUsuarios();
  }

  _initDatabaseAndLoadUsuarios() async {
    await _initDatabase();
  }

  _initDatabase() async {
    _database = DataBase();
    await _database.openDatabaseConnection();
  }

  Future<Map<String, dynamic>> _validarCredenciais(
      String username, String password) async {
    User? usuario = await _database.getUserByEmail(username);
    if (usuario?.username == username && usuario?.password == password) {
      return {'boolean': true, 'id': usuario?.id};
    }
    return {'boolean': false, 'id': null};
  }

  void handleUserName(TextEditingController value) {
    setState(() {
      _username = value;
    });
  }

  void handleSenha(TextEditingController value) {
    setState(() {
      _senha = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: 0,
                height: 50,
              ),
              SizedBox(
                width: 350,
                height: 250,
                child: Column(
                  children: [
                    TextField(
                      controller: _username,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Digite seu UserName',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.email, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _senha,
                      obscureText: true,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Digite sua senha',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> resultadoCredenciais =
                        await _validarCredenciais(
                      _username.text.trim(),
                      _senha.text.trim(),
                    );
                    if (!resultadoCredenciais['boolean']) {
                      return;
                    }
                    int usuarioId = resultadoCredenciais['id'] as int;
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Compras(usuarioId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Iniciar',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
